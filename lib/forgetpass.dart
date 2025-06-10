import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isLoading = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateInput);
  }

  void _validateInput() {
    setState(() {
      _isButtonEnabled = _emailController.text.isNotEmpty &&
          _emailController.text.contains('@');
    });
  }

  Future<void> _sendPasswordResetEmail() async {
    if (!_isButtonEnabled) return;

    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());

      setState(() {
        _message =
        'If an account exists for ${_emailController.text}, a password reset link has been sent.';
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Email Sent'),
          content: Text(
              'Check your inbox for the reset link for ${_emailController.text.trim()}.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _message = e.message ?? 'An error occurred.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Forgot Password'),
        centerTitle: true,
        backgroundColor: Colors.white,
        ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Enter your email address and we will send you a link to reset your password.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _isButtonEnabled
                    ? _sendPasswordResetEmail
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isButtonEnabled
                      ? Colors.amber
                      : Colors.grey,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(
                      fontSize: 16, color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Send Reset Link',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              if (_message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    _message,
                    style: TextStyle(
                        color: Colors.green.shade700, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
