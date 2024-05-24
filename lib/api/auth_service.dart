import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUpWithEmailAndPassword(String email, String password, String address, String phoneNo) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'address': address,
          'phoneNo': phoneNo,
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUserDetails(String uid, String address, String phoneNo) async {
  try {
    final QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();

    // Check if there is exactly one document that matches the query
    if (querySnapshot.docs.length == 1) {
      final DocumentSnapshot document = querySnapshot.docs.first;
      
      // Update the document with the new data
      await document.reference.update({
        'address': address,
        'phoneNo': phoneNo,
      });
    } else {
      print('Document not found or multiple documents found for the current user.');
    }
  } catch (e) {
    print('Failed to update user details: $e');
  }
}
}
