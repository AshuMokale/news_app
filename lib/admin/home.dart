import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/Login.dart' show AuthenticationPopup;

class AdminHome extends StatelessWidget {
  AdminHome({super.key});
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome Admin'),
            ElevatedButton.icon(
              onPressed: () {
                _signOut(context);
                Navigator.pushNamed(context, 'Login');
              },
              icon: Icon(Icons.logout_rounded),
              label: Text('Sign Out')
            ),
          ],
        ),
      ),
    );
  }
}