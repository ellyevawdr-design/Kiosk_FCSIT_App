import 'package:flutter/material.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/auth/screen/log_in_screen.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/main/screen/main_screen.dart';
//import 'package:routemaster/routemaster.dart';

final loggedInRoute = RouteMap(
  routes: {'/': (_) => const MaterialPage(child: MainScreen())},
);

final loggedOutRoute = RouteMap(
  routes: {'/': (_) => const MaterialPage(child: LogInScreen())},
);
