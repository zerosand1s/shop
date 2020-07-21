import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class SingleProductProvider with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavorite;

  SingleProductProvider({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String authToken) async {
    final url =
        'https://flutter-shop-3045c.firebaseio.com/products/$id.json?auth=$authToken';
    final currentFavoriteStatus = isFavorite;

    isFavorite = !currentFavoriteStatus;
    notifyListeners();

    try {
      final response = await http.patch(
        url,
        body: jsonEncode({'isFavorite': isFavorite}),
      );

      if (response.statusCode >= 400) {
        isFavorite = currentFavoriteStatus;
        notifyListeners();
        throw HttpException('Could not favorite product');
      }
    } catch (err) {
      isFavorite = currentFavoriteStatus;
      notifyListeners();
      throw HttpException('Could not favorite product');
    }
  }
}
