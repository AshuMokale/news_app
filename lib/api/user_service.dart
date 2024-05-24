import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('uid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Convert the data types as needed
        Map<String, dynamic> data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        if (data['phoneNo'] is int) {
          data['phoneNo'] = data['phoneNo'].toString();
        }
        return data;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
