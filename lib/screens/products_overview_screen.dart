import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../providers/cart_provider.dart';

import '../screens/cart_screen.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';

enum PopupMenuOptions { All, Favorites }

class ProductsOverviewScreen extends StatefulWidget {
  final String title;

  ProductsOverviewScreen({
    this.title,
  });

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _isLoading = false;
  var _showFavorites = false;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<ProductsProvider>(context).fetchProducts().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Badge(
                child: child,
                value: cart.itemCount.toString(),
              );
            },
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Show All Products'),
                value: PopupMenuOptions.All,
              ),
              PopupMenuItem(
                child: Text('Show Favorites Products'),
                value: PopupMenuOptions.Favorites,
              ),
            ],
            onSelected: (selectedValue) {
              setState(() {
                if (selectedValue == PopupMenuOptions.Favorites) {
                  _showFavorites = true;
                } else {
                  _showFavorites = false;
                }
              });
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showFavorites),
    );
  }
}
