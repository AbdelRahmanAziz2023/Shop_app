import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../module/Order_Provider.dart';

class OrderModel extends StatelessWidget {
  final OrderItem order;

  const OrderModel({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ExpansionTile(
        title: Text('\$${order.amount}'),
        subtitle: Text(DateFormat('dd/mm/yyyy hh:mm').format(order.dateTime)),
        children: order.products.map((item) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${item.quantity}x  \$${item.price}',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ],
            )).toList(),
      ),
    );
  }
}
