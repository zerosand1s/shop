import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';

import '../widgets/cart_item.dart';
import '../widgets/app_drawer.dart';

class CartScreen extends StatefulWidget {
  static final routeName = '/shopping_cart';
  final String title;

  CartScreen({
    this.title,
  });

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isPlacingOrder = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (context, i) => CartItem(
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: _isPlacingOrder
                ? CircularProgressIndicator()
                : RaisedButton(
                    onPressed: cart.itemCount <= 0
                        ? null
                        : () async {
                            setState(() {
                              _isPlacingOrder = true;
                            });

                            try {
                              await Provider.of<OrdersProvider>(context,
                                      listen: false)
                                  .addOrder(cart.items.values.toList(),
                                      cart.totalAmount);
                              cart.clearCart();
                            } catch (err) {
                              await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Error!'),
                                  content: Text(
                                      'Something went wrong. Please try again later.'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('OK'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    )
                                  ],
                                ),
                              );
                            } finally {
                              setState(() {
                                _isPlacingOrder = false;
                              });
                            }
                          },
                    color: Theme.of(context).accentColor,
                    child: Text(
                      'Order Now!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
