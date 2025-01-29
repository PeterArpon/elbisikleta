import 'package:flutter/material.dart';
import 'screens/SignInPage.dart';
import 'screens/SignUpPage.dart';
import 'screens/HomePage.dart';

void main() {
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
      routes: {
        '/': (context) => const HomePage(),
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