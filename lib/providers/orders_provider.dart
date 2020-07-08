import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../providers/cart_provider.dart';

class SingleOrderItem {
  final String id;
  final List<SingleCartItem> products;
  final double amount;
  final DateTime timestamp;

  SingleOrderItem({
    @required this.id,
    @required this.products,
    @required this.amount,
    @required this.timestamp,
  });
}

class OrdersProvider with ChangeNotifier {
  List<SingleOrderItem> _orders = [];

  List<SingleOrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    const url = 'https://flutter-shop-3045c.firebaseio.com/orders.json';

    try {
      final response = await http.get(url);
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final List<SingleOrderItem> loadedOrders = [];

      if (body == null) {
        return;
      }

      body.forEach((orderId, orderData) {
        loadedOrders.add(
          SingleOrderItem(
            id: orderId,
            amount: orderData['amount'],
            timestamp: DateTime.parse(orderData['timestamp']),
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => SingleCartItem(
                    id: item['id'],
                    title: item['title'],
                    price: item['price'],
                    quantity: item['quantity'],
                  ),
                )
                .toList(),
          ),
        );
      });

      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> addOrder(List<SingleCartItem> products, double amount) async {
    final timestamp = DateTime.now();

    try {
      const url = 'https://flutter-shop-3045c.firebaseio.com/orders.json';
      final response = await http.post(
        url,
        body: jsonEncode({
          'products': products
              .map((p) => {
                    'id': p.id,
                    'title': p.title,
                    'price': p.price,
                    'quantity': p.quantity
                  })
              .toList(),
          'amount': amount,
          'timestamp': timestamp.toIso8601String()
        }),
      );

      _orders.insert(
        0,
        SingleOrderItem(
          id: jsonDecode(response.body)['name'],
          products: products,
          amount: amount,
          timestamp: timestamp,
        ),
      );

      notifyListeners();

      return Future.value();
    } catch (err) {
      print(err);
      throw err;
    }
  }
}
