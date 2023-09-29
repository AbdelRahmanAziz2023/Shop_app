import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../module/Cart_Provider.dart';

class CartModel extends StatelessWidget {
  final String id;
  final String productId;
  final int quantity;
  final double price;
  final String title;

  const CartModel(
      {super.key,
      required this.id,
      required this.productId,
      required this.quantity,
      required this.price,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ValueKey(id),
        background: Container(
          color: Theme.of(context).errorColor,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(top: 20),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text('Do you want remove item from the cart?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('NO')),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text('Yes')),
                    ],
                  ));
        },
        onDismissed: (direction){
          Provider.of<Cart>(context,listen: false).removeItem(productId);
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              leading: CircleAvatar(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: FittedBox(
                    child: Text('\$$price'),
                  ),
                ),
              ),
              title: Text(title),
              subtitle: Text('Total \$${price * quantity}'),
              trailing: Text('$quantity'),
            ),
          ),
        ));
  }
}
