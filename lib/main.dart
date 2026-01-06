import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/auth/controller/auth_controller.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/auth/model/user_model.dart';
import 'package:networkclan_kiosk_fcsit_app/firebase_options.dart';
import 'package:networkclan_kiosk_fcsit_app/router.dart';
import 'package:networkclan_kiosk_fcsit_app/utils/color.dart';
import 'package:networkclan_kiosk_fcsit_app/utils/widgets/error_text.dart';
import 'package:networkclan_kiosk_fcsit_app/utils/widgets/loader.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  /// Fetch Firestore user data after FirebaseAuth login
  Future<void> loadUserData(User user) async {
    final stream = ref
        .read(authControllerProvider.notifier)
        .getUserData(user.uid);
    final userModel = await stream.first; // get current Firestore data
    ref.read(userProvider.notifier).state = userModel;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateChangeProvider);

    return authState.when(
      loading: () => const MaterialApp(home: Loader()),
      error: (error, _) =>
          MaterialApp(home: ErrorText(error: error.toString())),
      data: (firebaseUser) {
        // User not logged in
        if (firebaseUser == null) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            color: AppColor.primaryColor,
            routerDelegate: RoutemasterDelegate(
              routesBuilder: (_) => loggedOutRoute,
            ),
            routeInformationParser: const RoutemasterParser(),
          );
        }

        // User logged in → load Firestore user data
        final userModel = ref.watch(userProvider);
        if (userModel == null) {
          // Firestore data not loaded yet → show loader while fetching
          loadUserData(firebaseUser); // async fetch
          return const MaterialApp(home: Loader());
        }

        // Firestore data loaded → go to main page
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          color: AppColor.primaryColor,
          routerDelegate: RoutemasterDelegate(
            routesBuilder: (_) => loggedInRoute,
          ),
          routeInformationParser: const RoutemasterParser(),
        );
      },
    );
  }
}
