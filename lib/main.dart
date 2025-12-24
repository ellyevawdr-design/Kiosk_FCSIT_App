import 'package:flutter/material.dart';
import 'home.dart';
import 'menu.dart';
import 'customer_page.dart';
import 'order.dart';
import 'order_type.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      routes: {
        '/home': (context) => Home(),
        '/menu': (context) => Menu(),
        '/ordertype': (context) => OrderType(),
        '/order': (context) => Order(),
      },
    );
  }
}
