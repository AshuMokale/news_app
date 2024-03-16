import 'package:news_app/Login.dart' show AuthenticationPopup;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      AuthenticationPopup.show(context, 'User Signed Out.');
      // Navigate to login screen or perform any other action after sign out
    } catch (e) {
      print('Failed to sign out: $e');
      // Handle sign-out failure
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home Screen'),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _signOut(context);
                Navigator.pushNamed(context, 'Login');
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}