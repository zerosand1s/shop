import 'package:flutter/material.dart';

import '../models/product.dart';

import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem({
    @required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailsScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black45,
          leading: IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.white70,
            ),
            onPressed: null,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white70,
            ),
            onPressed: null,
          ),
        ),
      ),
    );
  }
}
