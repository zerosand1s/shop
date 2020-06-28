import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders_provider.dart';

import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static final routeName = '/orders';
  final String title;

  OrdersScreen({
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final allOrders = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: allOrders.orders.length,
        itemBuilder: (context, i) => OrderItem(allOrders.orders[i]),
      ),
    );
  }
}
