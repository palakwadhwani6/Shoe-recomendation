import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'google_service.dart';
import 'login.dart'; // Make sure this import points to your LoginPage file

class HomeScreen extends StatelessWidget {
  final User user;
  HomeScreen({super.key, required this.user});

  final GoogleAuthService _authService = GoogleAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${user.displayName}"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL ?? ""),
              radius: 40,
            ),
            Text("Email: ${user.email}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Sign out from Google and Firebase
                await _authService.signOut();

                // Navigate to LoginPage and replace the current screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.red.shade900,
              ),
              child: const Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}
