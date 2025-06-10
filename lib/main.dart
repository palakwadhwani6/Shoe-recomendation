import 'dart:io';

import 'package:first_project/cart_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first_project/login.dart';
import 'package:first_project/shoecatalog.dart';
import 'firebase_options.dart';
import 'database_helper.dart';
import 'user.dart';
import 'models/shoe.dart';
import 'service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase (for auth or Firestore if used later)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ Initialize SQLite DB and pre-fill default users
    final db = DatabaseHelper.instance;
    await db.initializeUsers();
    await db.printUsersToConsole();



  // ✅ Check if user is already logged in
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  print('Is logged in? $isLoggedIn');

  // ✅ Start the app
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shoe Recommendation App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: isLoggedIn ? const ShoeCatalogPage() : const LoginScreen(),
    );
  }
}
