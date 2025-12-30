import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/auth/controller/auth_controller.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/auth/model/user_model.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/menu/models/menu_model.dart';
import 'package:networkclan_kiosk_fcsit_app/firebase_options.dart';
import 'package:networkclan_kiosk_fcsit_app/router.dart';
import 'package:networkclan_kiosk_fcsit_app/utils/color.dart';
import 'package:networkclan_kiosk_fcsit_app/utils/widgets/error_text.dart';
import 'package:networkclan_kiosk_fcsit_app/utils/widgets/loader.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();

  Hive.registerAdapter(MenuModelAdapter());
  await Hive.openBox("menuFavourites");

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _userDataFetched = false;

  Future<void> _fetchUserData(User user) async {
    if (_userDataFetched) return; // prevent multiple calls
    final userModel = await ref
        .read(authControllerProvider.notifier)
        .getUserData(user.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
    _userDataFetched = true;
  }

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(authStateChangeProvider)
        .when(
          data: (user) {
            if (user != null) {
              _fetchUserData(user); // fetch only once
              return MaterialApp.router(
                color: AppColor.primaryColor,
                debugShowCheckedModeBanner: false,
                routerDelegate: RoutemasterDelegate(
                  routesBuilder: (context) => loggedInRoute,
                ),
                routeInformationParser: const RoutemasterParser(),
              );
            } else {
              return MaterialApp.router(
                color: AppColor.primaryColor,
                debugShowCheckedModeBanner: false,
                routerDelegate: RoutemasterDelegate(
                  routesBuilder: (context) => loggedOutRoute,
                ),
                routeInformationParser: const RoutemasterParser(),
              );
            }
          },
          error: (error, _) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
