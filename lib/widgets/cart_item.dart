import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  final String productId;
  final SingleCartItem item;

  CartItem(this.productId, this.item);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 30,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove this item from the cart?'),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        cart.removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  '\$${item.quantity * item.price}',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              radius: 30,
            ),
            title: Text(item.title),
            subtitle: Text('${item.quantity} x \$${item.price}'),
          ),
        ),
      ),
    );
  }
}
