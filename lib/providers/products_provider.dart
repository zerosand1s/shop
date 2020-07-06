import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './single_product_provider.dart';

class ProductsProvider with ChangeNotifier {
  List<SingleProductProvider> _items = [
    // SingleProductProvider(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // SingleProductProvider(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // SingleProductProvider(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // SingleProductProvider(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<SingleProductProvider> get items {
    return [..._items];
  }

  List<SingleProductProvider> get favoriteItems {
    return _items.where((p) => p.isFavorite).toList();
  }

  SingleProductProvider findById(id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> fetchProducts() async {
    const url = 'https://flutter-shop-3045c.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final List<SingleProductProvider> products = [];

      body.forEach((id, productObj) {
        products.add(SingleProductProvider(
          id: id,
          title: productObj['title'],
          description: productObj['description'],
          price: productObj['price'],
          imageUrl: productObj['imageUrl'],
          isFavorite: false,
        ));
      });

      _items = products;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> addProduct(SingleProductProvider product) async {
    // https://cdn.pixabay.com/photo/2013/07/12/13/43/diary-147191_960_720.png
    try {
      const url = 'https://flutter-shop-3045c.firebaseio.com/products.json';
      var response = await http.post(
        url,
        body: jsonEncode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl
        }),
      );

      final newProduct = SingleProductProvider(
        id: jsonDecode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      _items.add(newProduct);
      notifyListeners();
      return Future.value();
    } catch (err) {
      throw err;
    }
  }

  void updateProduct(String id, SingleProductProvider updatedProduct) {
    final index = _items.indexWhere((product) => product.id == id);

    if (index >= 0) {
      _items[index] = updatedProduct;
    } else {
      print('ERROR');
    }

    notifyListeners();
  }

  void deleteProduct(String id) {
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }
}
