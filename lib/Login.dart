import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:news_app/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Handle successful login, navigate to next screen, etc.
      // print('User logged in: ${userCredential.user!.email}');
      AuthenticationPopup.show(context, 'User logged in: ${userCredential.user!.email}');
      Timer(const Duration(seconds: 1), () {
        Navigator.pushNamed(context, 'Home');
      });
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomeScreen()), // Navigate to HomeScreen
      // );
    } catch (e) {
      // ignore: use_build_context_synchronously
      AuthenticationPopup.show(context, '$e');
      // print('Failed to log in: $e');
      // Handle login failure
    }
  }

  // Future<void> _signInWithEmailAndPassword() async {
  //   try {
  //     final credential = await _auth.signInWithEmailAndPassword(
  //       email: _emailController.text.trim(),
  //       password: _passwordController.text.trim(),
  //     );
  //     // ignore: avoid_print
  //     print(credential.user!.uid);
  //   } on FirebaseAuthException catch (e) {
  //       if (e.code == 'user-not-found') {
  //         print('No user found for that email.');
  //       } else if (e.code == 'wrong-password') {
  //         print('Wrong password provided for that user.');
  //       }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/login.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 38, top: 90),
              child: const Text(
                'Welcome\nPage',
                style: TextStyle(color: Colors.white, fontSize: 35),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5,
                    right: 35,
                    left: 35),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(250, 50),
                        ),
                        onPressed: () {
                          _signInWithEmailAndPassword(context);
                        },
                        child: const Text("Login")),
                        const SizedBox(height: 10),
                        ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(250, 50),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, 'Register');
                        },
                        child: const Text("Sign up"))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AuthenticationPopup {
  static void show(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Authentication'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
