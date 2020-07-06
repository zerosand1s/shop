import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

import '../screens/edit_product_screen.dart';

import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static final routeName = '/user-products';
  final String title;

  UserProductsScreen({this.title});

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final userProducts = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: userProducts.items.length,
            itemBuilder: (context, i) {
              return Column(
                children: <Widget>[
                  UserProductItem(
                    id: userProducts.items[i].id,
                    title: userProducts.items[i].title,
                    imageUrl: userProducts.items[i].imageUrl,
                  ),
                  Divider(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
