import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/module/Cart_Provider.dart';
import 'package:shop/module/Order_Provider.dart';
import 'package:shop/module/Products_Provider.dart';
import 'package:shop/screens/Auth_Screen.dart';
import 'package:shop/screens/Cart_Screen.dart';
import 'package:shop/screens/Edit_Product_Screen.dart';
import 'package:shop/screens/Order_Screen.dart';
import 'package:shop/screens/Product_Detail_Screen.dart';
import 'package:shop/screens/Product_Screen.dart';
import 'package:shop/screens/SplashScreen.dart';
import 'package:shop/screens/User_Product_Screen.dart';

import 'module/AuthProvider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: Auth()),
    ChangeNotifierProxyProvider<Auth, Products>(
      create: (_) => Products(),
      update: (ctx, authValue, previousProducts) => previousProducts!
        ..getData(authValue.token!, authValue.userId!, previousProducts.items),
    ),
    ChangeNotifierProvider.value(value: Cart()),
    ChangeNotifierProxyProvider<Auth, Order>(
      create: (_) => Order(),
      update: (ctx, authValue, previousOrders) => previousOrders!
        ..getData(authValue.token!, authValue.userId!, previousOrders.orders),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Shop',
              theme: ThemeData(
                primarySwatch: Colors.deepPurple,
                secondaryHeaderColor: Colors.cyanAccent[200],
                fontFamily: 'Lato',
              ),
             // home: CartScreen(),
              home: auth.isAuth
                  ? ProductScreen()
                  : FutureBuilder(
                      future: auth.tryAuthLogin(),
                      builder: (context, AsyncSnapshot snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen()),
              routes: {
                ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
                AuthScreen.routeName: (context) => AuthScreen(),
                ProductScreen.routeName: (context) => ProductScreen(),
                CartScreen.routeName: (context) => CartScreen(),
                OrderScreen.routeName: (context) => OrderScreen(),
                UserProductScreen.routeName: (context) => UserProductScreen(),
                EditProductScreen.routeName: (context) => EditProductScreen(),
              },
            ));
  }
}
