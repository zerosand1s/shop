import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/single_product_provider.dart';

import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<SingleProductProvider>(context);

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
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              product.toggleFavorite();
            },
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
