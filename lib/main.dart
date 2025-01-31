import 'package:elbisikleta/controllers/user_controller.dart';
import 'package:elbisikleta/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/SignInPage.dart';
import 'screens/SignUpPage.dart';
import 'screens/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elbisikleta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: UserController.user != null ? const HomePage() : const SignInPage(),
      routes: {
        // '/': (context) => const SignInPage(),
        '/sign-in': (context) => const SignInPage(),
        '/sign-up': (context) => const SignUpPage(),
        // '/homepage': (context) => const HomePage(),
        // '/map': (context) => const MapPage(),
        // '/rentals': (context) => const RentalsPage(),
        // '/profile': (context) => const ProfilePage(),
      },
    );
  }
}