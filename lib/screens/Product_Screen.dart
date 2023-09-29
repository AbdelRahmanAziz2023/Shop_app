import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/module/Products_Provider.dart';
import 'package:shop/screens/Cart_Screen.dart';
import 'package:shop/widgets/Badge.dart';
import 'package:shop/widgets/MyDrawer.dart';
import 'package:shop/widgets/Product_grid.dart';

import '../module/Cart_Provider.dart';

enum FilterOption {
  Favorites,
  All
}

class ProductScreen extends StatefulWidget {
  static const routeName = 'ProductScreen';

  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  var isLoading = false;
  var showOnlyFavorites = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) {
      setState(() => isLoading = false);
    })
        .catchError((error) {
      setState(() {
        print(error);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Shop',
          style: TextStyle(fontFamily: 'Anton', fontSize: 30),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<FilterOption>(
            onSelected: (FilterOption selectedVal) {
              setState(() {
                if (selectedVal == FilterOption.Favorites) {
                  showOnlyFavorites = true;
                } else {
                  showOnlyFavorites = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOption.Favorites,
                child: Text('Only Favorites'),
              ),
              const PopupMenuItem(
                value: FilterOption.All,
                child: Text('Show All'),
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, child) {
              return MyBadge(
                value: cart.itemCount.toString(),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                  icon: const Icon(Icons.shopping_cart),
                ),
              );
            },
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: ProductGrid(showFavs: showOnlyFavorites),
    );
  }
}