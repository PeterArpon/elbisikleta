import 'package:elbisikleta/controllers/user_controller.dart';
import 'package:elbisikleta/firebase_options.dart';
import 'package:elbisikleta/services/storage/storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/SignInPage.dart';
import 'screens/SignUpPage.dart';
import 'screens/HomePage.dart';
import 'screens/AddBikePage.dart';
import 'screens/ViewBikePage.dart';
import 'models/bike_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => StorageService(),
      child: const MyApp()
    )
  );
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
        '/add-bike': (context) => AddBikePage(
          ownerId: ModalRoute.of(context)!.settings.arguments as String,
        ),
        '/view-bike': (context) => ViewBikePage(
          bikeId: ModalRoute.of(context)!.settings.arguments as String,
        ),
        // '/homepage': (context) => const HomePage(),
        // '/map': (context) => const MapPage(),
        // '/rentals': (context) => const RentalsPage(),
        // '/profile': (context) => const ProfilePage(),
      },
    );
  }
}