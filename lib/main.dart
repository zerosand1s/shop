import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_details_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';

import './providers/auth_provider.dart';
import './providers/products_provider.dart';
import './providers/cart_provider.dart';
import './providers/orders_provider.dart';

import './helpers/custom_route.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Use "create" syntax whenever instantiating a new widget/object
        // Use ChangeNotifierProvider.value syntax when simply passing existing value
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          update: (context, authData, previousProducts) => ProductsProvider(
            authData.getToken,
            authData.getUserId,
            previousProducts != null ? previousProducts.items : [],
          ),
        ),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          update: (context, authData, previousOrders) => OrdersProvider(
            authData.getToken,
            authData.getUserId,
            previousOrders != null ? previousOrders : [],
          ),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authData, child) => MaterialApp(
          title: 'Shop',
          theme: ThemeData(
              primarySwatch: Colors.indigo,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
              textTheme: ThemeData.light().textTheme.copyWith(
                    title: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                    button: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
              appBarTheme: AppBarTheme(
                textTheme: ThemeData.light().textTheme.copyWith(
                      title: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder()
                },
              )),
          home: authData.isLoggedIn
              ? ProductsOverviewScreen(title: 'Shop')
              : FutureBuilder(
                  future: authData.autoLogin(),
                  builder: (context, shouldAutoLogin) =>
                      shouldAutoLogin.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailsScreen.routeName: (context) => ProductDetailsScreen(),
            CartScreen.routeName: (context) => CartScreen(title: 'Your Cart'),
            OrdersScreen.routeName: (context) =>
                OrdersScreen(title: 'Your Orders'),
            UserProductsScreen.routeName: (context) =>
                UserProductsScreen(title: 'Manage Your Products'),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
