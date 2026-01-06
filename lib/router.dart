import 'package:flutter/material.dart';
import 'package:networkclan_kiosk_fcsit_app/all_page.dart';
import 'package:networkclan_kiosk_fcsit_app/cart.dart';
import 'package:networkclan_kiosk_fcsit_app/drink_page.dart';
import 'package:networkclan_kiosk_fcsit_app/favorite.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/auth/screen/log_in_screen.dart';
import 'package:networkclan_kiosk_fcsit_app/meal_page.dart';
import 'package:networkclan_kiosk_fcsit_app/profile_page.dart';
import 'package:networkclan_kiosk_fcsit_app/snack_page.dart';
import 'package:routemaster/routemaster.dart';
import 'package:networkclan_kiosk_fcsit_app/customer_page.dart';
import 'package:networkclan_kiosk_fcsit_app/home.dart';
import 'package:networkclan_kiosk_fcsit_app/menu.dart';
import 'package:networkclan_kiosk_fcsit_app/order.dart';
import 'package:networkclan_kiosk_fcsit_app/order_type.dart';
import 'package:networkclan_kiosk_fcsit_app/payment_method_page.dart';

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: CustomerPage()),
    '/home': (_) => const MaterialPage(child: Home()),
    '/menu': (_) => const MaterialPage(child: Menu()),
    '/order': (_) => const MaterialPage(child: OrderPage()),
    '/order_type': (_) => const MaterialPage(child: OrderType()),
    '/logout': (_) => const MaterialPage(child: LogInScreen()),
    '/meal': (_) => const MaterialPage(child: MealPage()),
    '/drink': (_) => const MaterialPage(child: DrinkPage()),
    '/snack': (_) => const MaterialPage(child: SnackPage()),
    '/all': (_) => const MaterialPage(child: AllPage()),
    '/cart': (_) => const MaterialPage(child: CartPage()),
    '/favorite': (_) => const MaterialPage(child: FavoritePage()),
  },
);

final loggedOutRoute = RouteMap(
  routes: {'/': (_) => const MaterialPage(child: LogInScreen())},
);
