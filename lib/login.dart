import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'google_service.dart';
import 'register.dart';
import 'shoecatalog.dart';
import 'forgetpass.dart';
import 'service.dart'; // Helper class for preferences

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final GoogleAuthService _authService = GoogleAuthService();

  bool _isLoginButtonEnabled = false;
  bool _isLoading = false;


 

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateInputs);
    _passwordController.addListener(_validateInputs);
    _usernameController.addListener(_validateInputs);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    setState(() {
      _isLoginButtonEnabled = _emailController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty && _usernameController.text.trim().isNotEmpty;
    });
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() => _isLoading = true);

    try {
      await PreferencesService.setLoginData(email: email,username:_usernameController.text);
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await PreferencesService.getLoginData(email:email,username:_usernameController.text);
      final userCerdential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {

        // Prevent back button from returning to LoginScreen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const ShoeCatalogPage()),
              (route) => false,
        );
      } else {
        _showDialog('Login Failed', 'Please try again.');
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-credential':
          message = 'Invalid credentials. Please try again.';
          break;
        case 'invalid-email':
          message = 'Invalid email format.';
          break;
        case 'user-not-found':
          message = 'No user found for this email.';
          break;
        case 'wrong-password':
          message = 'Wrong password.';
          break;
        default:
          message = 'Login failed: ${e.message}';
      }
      _showDialog('Error', message);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    final user = await _authService.signInWithGoogle();
    if (user != null) {
      await PreferencesService.setLoginData(email: user.email ?? '', username: _usernameController.text);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ShoeCatalogPage()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false, // No back arrow
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: 300,
            child: Column(
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen()),
                      );
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ShoeCatalogPage()),
                      );
                    },
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text('Login'),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(thickness: 1),
                const SizedBox(height: 20),

                /// Google Login
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 2,
                  child: InkWell(
                    onTap: _loginWithGoogle,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      width: double.infinity,
                      child: const Center(child: Text('Log in with Google')),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                /// Facebook Login (Not implemented)
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 2,
                  child: InkWell(
                    onTap: () => _showDialog(
                        'Coming Soon', 'Facebook login is not yet implemented.'),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      width: double.infinity,
                      child: const Center(child: Text('Log in with Facebook')),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /// Registration Prompt
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Not a member?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CreateAccountScreen()),
                        );
                      },
                      child: const Text(
                        " Join Now",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

