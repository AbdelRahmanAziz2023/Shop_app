import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/module/Order_Provider.dart';
import 'package:shop/screens/Order_Screen.dart';
import 'package:shop/widgets/Cart_model.dart';
import 'package:shop/widgets/MyDrawer.dart';

import '../module/Cart_Provider.dart';

class CartScreen extends StatefulWidget {
  static const routeName = 'CartScreen';

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(fontFamily: 'Anton', fontSize: 30),
        ),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, int index) => CartModel(
                        id: cart.items.values.toList()[index].id,
                        productId: cart.items.keys.toList()[index],
                        quantity: cart.items.values.toList()[index].quantity,
                        price: cart.items.values.toList()[index].price,
                        title: cart.items.values.toList()[index].title,
                      )))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart cart;

  const OrderButton({super.key, required this.cart});

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (widget.cart.totalPrice <= 0 || isLoading)
            ? null
            : () async {
                setState(() {
                  isLoading = true;
                });
                await Provider.of<Order>(context, listen: false).addOrder(
                    widget.cart.items.values.toList(), widget.cart.totalPrice);
                setState(() {
                  isLoading = false;
                });
                widget.cart.clear();
                Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
              },
        child: isLoading
            ? const CircularProgressIndicator()
            : const Text('ORDER NOW'));
  }
}
