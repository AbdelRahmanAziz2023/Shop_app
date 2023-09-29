import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/Edit_Product_Screen.dart';
import 'package:shop/widgets/MyDrawer.dart';
import 'package:shop/widgets/User_Product_Item.dart';

import '../module/Products_Provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = 'userScreen';

  const UserProductScreen({Key? key}) : super(key: key);

  Future<void> refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Products',
          style: TextStyle(fontFamily: 'Anton', fontSize: 30),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: FutureBuilder(
        future: refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productData, _) => Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListView.builder(
                          itemCount: productData.items.length,
                          itemBuilder: (_, index) => Column(
                            children: [
                              UserProductItem(
                                id: productData.items[index].id,
                                title: productData.items[index].title,
                                imageUrl: productData.items[index].imageUrl,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
