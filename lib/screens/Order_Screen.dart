import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/module/Order_Provider.dart';
import 'package:shop/widgets/MyDrawer.dart';
import 'package:shop/widgets/Order_model.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = 'OrderScreen';

  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(fontFamily: 'Anton', fontSize: 30),
        ),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: FutureBuilder(
          future:
              Provider.of<Order>(context, listen: false).fetchAndSetOrders(),
          builder: (_, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (Provider
                  .of<Order>(context,)
                  .orders
                  .isEmpty) {
                return Center(child: Text('You do not have any order yet!'),);
              }
              else if (snapshot.error != null) {
                return const Center(
                  child: Text('An error occurred!'),
                );
              } else {
                return Consumer<Order>(
                    builder: (ctx, orderData, child) =>
                        ListView.builder(
                          itemCount: orderData.orders.length,
                          itemBuilder: (context, index) =>
                              OrderModel(order: orderData.orders[index]),
                        ));
              }
            }
          }),
    );
  }
}
