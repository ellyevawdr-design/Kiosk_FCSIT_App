import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/menu/models/menu_model.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/main/screen/main_screen.dart';
import 'package:networkclan_kiosk_fcsit_app/utils/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Hive adapter for MenuModel
  Hive.registerAdapter(MenuModelAdapter());
  await Hive.openBox("menuFavourites");

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Fully offline app — directly show MainScreen
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Offline Kiosk App",
      theme: ThemeData(primaryColor: AppColor.primaryColor),
      home: const MainScreen(),
    );
  }
}
