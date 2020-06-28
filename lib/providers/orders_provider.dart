import 'package:flutter/material.dart';

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

  void addOrder(List<SingleCartItem> products, double amount) {
    _orders.insert(
      0,
      SingleOrderItem(
        id: DateTime.now().toString(),
        products: products,
        amount: amount,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
