import 'package:flutter/material.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/auth/screen/log_in_screen.dart';
import 'package:routemaster/routemaster.dart';
import 'package:networkclan_kiosk_fcsit_app/customer_page.dart';
import 'package:networkclan_kiosk_fcsit_app/home.dart';
import 'package:networkclan_kiosk_fcsit_app/menu.dart';
import 'package:networkclan_kiosk_fcsit_app/order.dart';
import 'package:networkclan_kiosk_fcsit_app/order_type.dart';

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: CustomerPage()),
    '/home': (_) => const MaterialPage(child: Home()),
    '/menu': (_) => const MaterialPage(child: Menu()),
    '/order': (_) => const MaterialPage(child: Order()),
    '/order_type': (_) => const MaterialPage(child: OrderType()),
    '/logout': (_) => const MaterialPage(child: LogInScreen()),
  },
);

final loggedOutRoute = RouteMap(
  routes: {'/': (_) => const MaterialPage(child: LogInScreen())},
);
