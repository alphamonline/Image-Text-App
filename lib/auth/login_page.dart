import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_text_app/auth/register_page.dart';
import '../components/login_button.dart';
import '../components/my_textfield.dart';
import '../components/square_tile.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() {
    _loginUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // logo
              const Icon(
                Icons.login,
                size: 100,
                color: Colors.indigo,
              ),

              const SizedBox(height: 50),

              // welcome back, you've been missed!
              Text(
                'Welcome back you\'ve been missed!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              // username textfield
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // forgot password?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // sign in button
              LoginButton(
                onTap: signUserIn,
              ),

              const SizedBox(height: 20),

              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // google + apple sign in buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // google button
                  GestureDetector(
                    onTap: () {
                      print("WTF");
                    },
                    child: const SquareTile(imagePath: 'lib/images/phone.png'),
                  ),

                  const SizedBox(width: 25),

                  // apple button
                  GestureDetector(
                    onTap: () {
                      _googleSignIn();
                    },
                    child: const SquareTile(imagePath: 'lib/images/google.png'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Do not have an account yet?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => _registerPage(context),
                    child: const Text(
                      'Register now',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Perform login
  Future<void> _loginUser() async {
    Timer(const Duration(seconds: 3), () {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
    });

    try {
      await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        _noUserSnack();
      } else if (e.code == 'wrong-password') {
        _wrongPassSnack();
      }
    } finally {}
  }

  void _googleSignIn() async {
    Timer(const Duration(seconds: 3), () {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
    });

    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void _noUserSnack() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text(
        'Email does not exist. Please sign in with google.',
        style: TextStyle(color: Colors.white),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.redAccent.shade200,
    ));
  }

  void _wrongPassSnack() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text(
        'Password does not match our records',
        style: TextStyle(color: Colors.white),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.redAccent.shade200,
    ));
  }

  void _registerPage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
        fullscreenDialog: true,
      ),
    );
  }
}
