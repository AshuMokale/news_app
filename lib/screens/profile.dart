import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/auth_service.dart';
import '../api/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      Map<String, dynamic>? userData = await _userService.getUserDetails(user.uid);
      if (userData != null) {
        setState(() {
          _addressController.text = userData['address'] ?? '';
          _phoneNoController.text = userData['phoneNo'] ?? '';
        });
      }
    }
  }

  Future<void> _updateUserDetails() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _authService.updateUserDetails(
        user.uid,
        _addressController.text,
        _phoneNoController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Details Updated')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _phoneNoController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUserDetails,
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
