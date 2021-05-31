import 'package:flutter/foundation.dart';
import 'package:shop/providers/product.dart';

class CartItem {
  final String id;
  final Product product;
  int quantity;

  get totalPrice {
    return quantity * product.price;
  }

  CartItem({
    @required this.id,
    @required this.quantity,
    @required this.product,
  });
}

class Cart with ChangeNotifier {
  final String authToken;
  List<CartItem> _items = [];

  Cart(this.authToken, this._items);

  List<CartItem> get items {
    return [..._items];
  }

  void addItem(Product product) {
    // Find product in cart
    int indexInCart =
        _items.indexWhere((element) => element.product.id == product.id);

    if (indexInCart >= 0) {
      // Increase amount by one
      _items[indexInCart].quantity++;
    } else {
      // Add to cart
      _items.add(
        CartItem(
          id: DateTime.now().toString(),
          quantity: 1,
          product: product,
        ),
      );
    }

    notifyListeners();
  }

  void removeFullItem(CartItem cartItem) {
    _items.removeWhere((element) => element.id == cartItem.id);
    notifyListeners();
  }

  void removeSingleProduct(Product product) {
    CartItem ci =
        _items.firstWhere((element) => element.product.id == product.id);
    if (ci.quantity > 1) {
      ci.quantity--;
    } else {
      removeFullItem(ci);
    }

    notifyListeners();
  }

  void emptyCart() {
    _items = [];
    notifyListeners();
  }

  int get count => _items.length;

  double get totalPrice =>
      _items.map((e) => e.totalPrice).toList().fold(0, (p, c) => p + c);
}
