import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/module/AuthProvider.dart';
import 'package:shop/module/Product_Provider.dart';
import 'package:shop/screens/Product_Detail_Screen.dart';

import '../module/Cart_Provider.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context,listen: false);
    final cart = Provider.of<Cart>(context,listen: false);
    final authData = Provider.of<Auth>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) =>
                IconButton(
                    onPressed: () {product.toggleFavoriteStatus(authData.token!, authData.userId!);},
                    icon: Icon(product.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border)),
          ),
          title: Text(product.title, textAlign: TextAlign.center,),
          trailing: IconButton(onPressed: () {
            cart.addItem(product.id, product.price, product.title);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: const Text("Added to cart!"),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(label: "UNDO!", onPressed: () {
                    cart.removeSingleItem(product.id);
                  }),
                )
            );
          }, icon: const Icon(Icons.shopping_cart)),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,arguments: product.id);
          },
          child: Hero(
              tag: product.id,
              child: FadeInImage(
                  fit: BoxFit.cover,
                  placeholder:
                  const AssetImage('assets/images/product-placeholder.png'),
                  image: NetworkImage(product.imageUrl))),
        ),
      ),
    );
  }
}
