import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem({
    @required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(
        product.imageUrl,
        fit: BoxFit.contain,
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
    );
  }
}
