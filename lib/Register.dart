import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:news_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/Login.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();

  Future<void> _registerWithEmailAndPassword(BuildContext context) async {
    if (_passwordController.text.trim() == _passwordController2.text.trim()) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        // Check if userCredential is not null
        if (userCredential.user != null) {
          // If userCredential is not null, registration is successful
          // Show popup for registered
          AuthenticationPopup.show(context, 'Registered successfully');
          Timer(const Duration(seconds: 1), () {
            Navigator.pushNamed(context, 'Login');
          });
          // You can also sign in the user automatically after registration
          // For example:
          // await _signInWithEmailAndPassword(context);
        } else {
          // Handle null userCredential (registration failed)
          AuthenticationPopup.show(context, 'Registration failed. Please try again.');
        }
      } catch (e) {
        print('Failed to register: $e');
        // Handle registration failure
        AuthenticationPopup.show(context, 'Registration failed. Please try again.');
      }
    } else {
      AuthenticationPopup.show(context, 'Passwords do not match!');
    }
  }

//   Future<void> _registerWithEmailAndPassword(BuildContext context) async {
//   try {
//     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//       email: _emailController.text.trim(),
//       password: _passwordController.text.trim(),
//     );
//     // Check if userCredential is not null
//     if (userCredential.user != null) {
//       // If userCredential is not null, registration is successful
//       // Show popup for registered
//       AuthenticationPopup.show(context, 'Registered successfully');
//       Timer(const Duration(seconds: 1), () {
//         Navigator.pushNamed(context, 'Login');
//       });
//       // You can also sign in the user automatically after registration
//       // For example:
//       // await _signInWithEmailAndPassword(context);
//     } else {
//       // Handle null userCredential (registration failed)
//       AuthenticationPopup.show(context, 'Registration failed. Please try again.');
//     }
//   } catch (e) {
//     print('Failed to register: $e');
//     // Handle registration failure
//     AuthenticationPopup.show(context, 'Registration failed. Please try again.');
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/register.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 30),
              child: const Text(
                'Create\nAccount',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          // TextField(
                          //   style: const TextStyle(color: Colors.white),
                          //   decoration: InputDecoration(
                          //       enabledBorder: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(10),
                          //         borderSide: const BorderSide(
                          //           color: Colors.white,
                          //         ),
                          //       ),
                          //       focusedBorder: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(10),
                          //         borderSide: const BorderSide(
                          //           color: Colors.black,
                          //         ),
                          //       ),
                          //       hintText: "Name",
                          //       hintStyle: const TextStyle(color: Colors.white),
                          //       border: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(10),
                          //       )),
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            style: const TextStyle(color: Colors.white),
                            controller: _emailController,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Email",
                                hintStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            style: const TextStyle(color: Colors.white),
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Password",
                                hintStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            style: const TextStyle(color: Colors.white),
                            controller: _passwordController2,
                            obscureText: true,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Confirm Password",
                                hintStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _registerWithEmailAndPassword(context);
                                },
                                child: Text('Register'),
                                //  style: ButtonStyle(
                                //       color: Colors.white,
                                //       fontSize: 27,
                                //       fontWeight: FontWeight.w700),
                                // ),
                                // CircleAvatar(
                                //   radius: 30,
                                //   backgroundColor: const Color(0xff4c505b),
                                //   child: IconButton(
                                //       color: Colors.white,
                                //       onPressed: () {},
                                //       icon: const Icon(
                                //         Icons.arrow_forward,
                                //       )),
                                // )
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const MyLogin()),
                                  );
                                },
                                child: const Text(
                                  'Sign In',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.black,
                                      fontSize: 18),
                                ),
                                // style: const ButtonStyle(),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
