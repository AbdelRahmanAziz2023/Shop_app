import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/module/Cart_Provider.dart';

class OrderItem {
  final String id;
  final DateTime dateTime;
  final List<CartItem> products;
  final double amount; // Corrected variable name

  OrderItem({
    required this.id,
    required this.dateTime,
    required this.products,
    required this.amount, // Corrected variable name
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = []; // Corrected variable name
  String authToken = '';
  String userId = '';

  void getData(String authToken, String userId, List<OrderItem> orders) { // Corrected parameter names
    this.authToken = authToken; // Use 'this' keyword to distinguish between class variable and parameter
    this.userId = userId; // Use 'this' keyword to distinguish between class variable and parameter
    _orders = orders; // Corrected variable name
    notifyListeners();
  }

  List<OrderItem> get orders { // Corrected function name
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://shop-30bd5-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }

      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          dateTime: DateTime.parse(orderData['dateTime']),
          amount: orderData['amount'], // Corrected variable name
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
              id: item['id'],
              title: item['title'],
              quantity: item['quantity'],
              price: item['price']))
              .toList(),
        ));
      });
      _orders = loadedOrders; // Corrected variable name
      notifyListeners();
    } catch (error) { // Renamed variable to 'error' for consistency
      print('error 2.1');
      print(error); // Renamed variable to 'error' for consistency
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async { // Corrected parameter name
    final url =
        'https://shop-30bd5-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final timestamp = DateTime.now();
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartProducts
                .map((item) => {
              'id': item.id,
              'title': item.title,
              'quantity': item.quantity,
              'price': item.price
            })
                .toList()
          }));
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          dateTime: timestamp,
          products: cartProducts,
          amount: total, // Corrected variable name
        ),
      );
      notifyListeners();
    } catch (error) { // Renamed variable to 'error' for consistency
      print('error 2.2');
      print(error); // Renamed variable to 'error' for consistency
      rethrow;
    }
  }
}