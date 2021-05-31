import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shop/constants.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/product.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime orderTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.orderTime,
  });
}

class Orders with ChangeNotifier {
  final String authToken;
  final String userId;
  List<OrderItem> _items = [];

  Orders(this.authToken, this.userId, this._items);

  List<OrderItem> get items {
    return [..._items];
  }

  void addOrder(List<CartItem> currentCart, double total) {
    var orderItem = OrderItem(
      id: DateTime.now().toString(),
      amount: total,
      products: currentCart,
      orderTime: DateTime.now(),
    );

    _items.insert(0, orderItem);

    Uri url = Uri.parse(
        FIREBASE_BACKEND_URL + "/orders/$userId.json?auth=$authToken");

    http.post(url,
        body: json.encode({
          "amount": orderItem.amount,
          "orderTime": orderItem.orderTime.toString(),
          "products": orderItem.products
              .map((e) => {
                    "product_name": e.product.title,
                    "product_price": e.product.price,
                    "quantity": e.quantity,
                  })
              .toList()
        }));
    notifyListeners();
  }

  Future<Null> fetchOrders() async {
    Uri url = Uri.parse(
        FIREBASE_BACKEND_URL + "/orders/$userId.json?auth=$authToken");

    var response = await http.get(url);
    var responseData = json.decode(response.body) as Map<String, dynamic>;

    List<OrderItem> newOrderList = [];

    responseData.forEach((key, value) {
      var products = value['products'] as List<dynamic>;
      var ciList = products
          .map((e) => CartItem(
                id: null,
                quantity: e['quantity'],
                product: Product(
                  id: null,
                  title: e["product_name"],
                  description: null,
                  imageUrl: null,
                  price: e['product_price'],
                ),
              ))
          .toList();

      OrderItem oi = OrderItem(
          id: key,
          amount: value['amount'],
          orderTime: DateTime.parse(value['orderTime']),
          products: ciList);

      newOrderList.add(oi);
    });

    _items = newOrderList;
    notifyListeners();
  }
}
