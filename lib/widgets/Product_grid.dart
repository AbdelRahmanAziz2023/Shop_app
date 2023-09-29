import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/module/Products_Provider.dart';
import 'package:shop/widgets/Product_Item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavs;

  const ProductGrid({super.key, required this.showFavs});

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = showFavs ? productData.favoriteItems : productData.items;
    return products.isEmpty?const Center(child:Text("There is no product!"),):GridView.builder(
      itemCount: products.length,
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: products[i],
              child: ProductItem(),
            ));
  }
}
