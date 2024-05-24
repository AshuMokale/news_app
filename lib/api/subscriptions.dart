import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateSubscription(String userId, String subscriptionType, DateTime startDate, DateTime endDate) async {
    try {
      await _firestore.collection('subscriptions').doc(userId).set({
        'userId': userId,
        'subscriptionType': subscriptionType,
        'startDate': startDate,
        'endDate': endDate,
        'status': 'active',
      });
    } catch (e) {
      print('Failed to update subscription: $e');
    }
  }

  Future<Map<String, dynamic>?> getSubscriptionDetails(String userId) async {
    try {
      final doc = await _firestore.collection('subscriptions').doc(userId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      print('Failed to get subscription details: $e');
      return null;
    }
  }
}
