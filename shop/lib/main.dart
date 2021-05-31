import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/screen/auth_screen.dart';
import 'package:shop/screen/cart_screen.dart';
import 'package:shop/screen/product_form_screen.dart';
import 'package:shop/screen/orders_screen.dart';

import 'package:shop/screen/product_detail_screen.dart';
import 'package:shop/screen/product_overview_screen.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/screen/splash_screen.dart';
import 'package:shop/screen/user_products_screen.dart';

void main() {
  runApp(MyApp());
}

var appthemeData = ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.amber,
  fontFamily: 'Lato',
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(null, null, []),
          update: (_, auth, prevProducts) =>
              Products(auth.token, auth.userID, prevProducts.items),
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
          create: (_) => Cart(null, []),
          update: (_, auth, prevCart) => Cart(auth.token, prevCart.items),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(null, null, []),
          update: (_, auth, prevOrders) =>
              Orders(auth.token, auth.userID, prevOrders.items),
        ),
      ],
      child: Consumer<Auth>(
        builder: (_, authData, __) => MaterialApp(
          title: 'Mobile Shop',
          theme: appthemeData,
          home: authData.isAuthenticated
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            ProductFormScreen.routeName: (ctx) => ProductFormScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
          },
        ),
      ),
    );
  }
}
