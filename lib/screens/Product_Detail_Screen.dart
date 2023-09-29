import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/module/Products_Provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = 'ProductDetail';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String productId =ModalRoute.of(context)!.settings.arguments as String ;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(loadedProduct.title,style:TextStyle(color:Colors.black38),),
                background: Hero(
                    tag: productId,
                    child: Image.network(
                      loadedProduct.imageUrl,
                    )),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              const SizedBox(
                height: 15,
              ),
              Text(
                '\$${loadedProduct.price}',
                style: const TextStyle(color: Colors.grey, fontSize: 30),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  loadedProduct.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style:TextStyle(fontSize:30),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ]))
          ],
        ));
  }
}
