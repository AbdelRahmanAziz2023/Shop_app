import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/module/Products_Provider.dart';
import 'package:shop/screens/Edit_Product_Screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem({super.key,
    required this.id,
    required this.title,
    required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () =>
                    Navigator.of(context)
                        .pushNamed(EditProductScreen.routeName),
                icon: const Icon(Icons.edit)),
            IconButton(onPressed: () async {
              try {
                await Provider.of<Products>(context, listen: false)
                    .deleteProduct(id);
              } catch (e) {
                scaffold.showSnackBar(const SnackBar(content: Text(
                  'Deleting failed!', textAlign: TextAlign.center,)));
              }
            }, icon: const Icon(Icons.delete), color: Theme
                .of(context)
                .errorColor,),
          ],
        ),
      ),
    );
  }
}
