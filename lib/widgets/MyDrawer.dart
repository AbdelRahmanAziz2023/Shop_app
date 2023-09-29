import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/Auth_Screen.dart';
import 'package:shop/screens/Order_Screen.dart';
import 'package:shop/screens/Product_Screen.dart';
import 'package:shop/screens/User_Product_Screen.dart';

import '../module/AuthProvider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'Options',
              style: TextStyle(fontFamily: 'Anton', fontSize: 30),
            ),
            centerTitle: true,
          ),
          const SizedBox(height: 5),
          ListTile(
            title: const Text(
              'Shop',
              style: TextStyle(fontSize: 22, fontFamily: 'Lato'),
            ),
            leading: const Icon(Icons.shop, size: 30),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(ProductScreen.routeName);
            },
          ),
          const Divider(thickness: 2),
          ListTile(
            title: const Text(
              'Orders',
              style: TextStyle(fontSize: 22, fontFamily: 'Lato'),
            ),
            leading: const Icon(Icons.add_shopping_cart, size: 30),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
          ),
          const Divider(thickness: 2),
          ListTile(
            title: const Text(
              'Manage My Products',
              style: TextStyle(fontSize: 22, fontFamily: 'Lato'),
            ),
            leading: const Icon(Icons.manage_accounts, size: 30),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName);
            },
          ),
          const Divider(thickness: 2),
          ListTile(
            title: const Text(
              'Logout',
              style: TextStyle(fontSize: 22, fontFamily: 'Lato'),
            ),
            leading: const Icon(Icons.logout, size: 30),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
          const Divider(thickness: 2),
        ],
      ),
    );
  }
}