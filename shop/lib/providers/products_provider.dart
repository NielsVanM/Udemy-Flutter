import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'package:shop/constants.dart';
import 'package:shop/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return [..._items.where((element) => element.isFavorite).toList()];
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    _items = [];

    final filterString =
        filterByUser ? "orderBy=\"creatorID\"&equalTo=\"$userId\"&" : "";

    Uri url = Uri.parse(
        FIREBASE_BACKEND_URL + "products.json?${filterString}auth=$authToken");

    http.Response resp = await http.get(url);
    var body = json.decode(resp.body) as Map<String, dynamic>;
    if (body == null) {
      return;
    }

    url = Uri.parse(
        FIREBASE_BACKEND_URL + "userFavorites/$userId.json?auth=$authToken");

    var favoriteResponse = await http.get(url);
    var favoritesData =
        json.decode(favoriteResponse.body) as Map<String, dynamic>;

    body.forEach((prodID, value) {
      Product p = Product(
        id: prodID,
        title: value['title'],
        description: value['description'],
        price: value['price'],
        imageUrl: value["imageUrl"],
        isFavorite:
            favoritesData == null ? false : favoritesData[prodID] ?? false,
      );

      _items.add(p);
    });

    notifyListeners();
  }

  Future<Null> add(Product product) async {
    var url = Uri.parse(FIREBASE_BACKEND_URL + "products.json?auth=$authToken");

    try {
      http.Response response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorID': userId,
        }),
      );

      product = product.copyWith(
        id: json.decode(response.body)['name'],
      );
      _items.add(product);

      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future<Null> update(Product product) async {
    var url = Uri.parse(
        FIREBASE_BACKEND_URL + "products/${product.id}.json?auth=$authToken");

    try {
      http.patch(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
        }),
      );

      int index = _items.indexWhere((element) => element.id == product.id);
      _items[index] = product;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  // Adds or Updates an product based on the presence of an ID.
  Future<Null> addOrUpdate(Product product) {
    if (product.id == null) {
      return add(product);
    } else {
      return update(product);
    }
  }

  Future<Null> toggleFavorite(Product product, String userId) async {
    var url = Uri.parse(FIREBASE_BACKEND_URL +
        "userFavorites/$userId/${product.id}.json?auth=$authToken");

    bool oldProductFavorite = product.isFavorite;
    bool newProductFavorite = !product.isFavorite;

    product.isFavorite = newProductFavorite;
    notifyListeners();
    try {
      var resp = await http.put(
        url,
        body: json.encode(newProductFavorite),
      );

      if (resp.statusCode >= 400) {
        throw HttpException("Update request failed");
      }
    } catch (e) {
      product.isFavorite = oldProductFavorite;
    }
    notifyListeners();
  }

  Product findByID(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void deleteProduct(String id) {
    var url =
        Uri.parse(FIREBASE_BACKEND_URL + "products/$id.json?auth=$authToken");

    var existingProductIndex = _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);

    http.delete(url).then((value) {
      existingProduct = null;
      existingProductIndex = null;
    }).catchError(() {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
    });

    notifyListeners();
  }
}
