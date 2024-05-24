import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../api/auth_service.dart';
import '../api/subscriptions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();
  final SubscriptionService _subscriptionService = SubscriptionService();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final Razorpay _razorpay = Razorpay();

  String _subscriptionType = '';
  DateTime? _subscriptionEndDate;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      Map<String, dynamic>? userData = await _authService.getUserDetails(user.uid);
      if (userData != null) {
        setState(() {
          _addressController.text = userData['address'] ?? '';
          _phoneNumberController.text = userData['phoneNo'] ?? '';
        });
      }

      Map<String, dynamic>? subscriptionData = await _subscriptionService.getSubscriptionDetails(user.uid);
      if (subscriptionData != null) {
        setState(() {
          _subscriptionType = subscriptionData['subscriptionType'] ?? '';
          _subscriptionEndDate = subscriptionData['endDate'] != null
              ? (subscriptionData['endDate'] as Timestamp).toDate()
              : null;
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
        _phoneNumberController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Details Updated')));
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DateTime startDate = DateTime.now();
      DateTime endDate;

      if (_subscriptionType == 'monthly') {
        endDate = startDate.add(Duration(days: 30));
      } else if (_subscriptionType == 'yearly') {
        endDate = startDate.add(Duration(days: 365));
      } else {
        // Provide a default value or handle the case where subscriptionType is not set
        endDate = startDate.add(Duration(days: 30)); // Default to monthly
      }

      await _subscriptionService.updateSubscription(user.uid, _subscriptionType, startDate, endDate);
      setState(() {
        _subscriptionEndDate = endDate;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Subscribed successfully')));
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment failed: ${response.message}')));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('External wallet selected')));
  }

  void _openCheckout(String subscriptionType) async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _subscriptionType = subscriptionType;
      });

      var options = {
        'key': 'rzp_test_BNuKWkXYHC8QRe',
        'amount': subscriptionType == 'monthly' ? 10000 : 100000,
        'currency': 'INR', // Specify the currency code
        'name': 'Subscription',
        'description': 'Subscription Payment',
        'prefill': {
          'contact': _phoneNumberController.text,
          'email': user.email,
        },
        'external': {
          'wallets': ['paytm']
        }
      };

      try {
        _razorpay.open(options);
      } catch (e) {
        print(e.toString());
      }
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Update Profile'),
              SizedBox(height: 10),
              _buildTextField('Address', _addressController, Icons.home),
              SizedBox(height: 16),
              _buildTextField('Phone Number', _phoneNumberController, Icons.phone, keyboardType: TextInputType.phone),
              SizedBox(height: 16),
              _buildUpdateButton(),
              Divider(height: 40),
              _buildSectionTitle('Subscription'),
              _buildSubscriptionInfo(),
              _buildSubscriptionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildUpdateButton() {
    return ElevatedButton(
      onPressed: _updateUserDetails,
      child: const Text('Update Details'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildSubscriptionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Current Subscription: $_subscriptionType'),
        if (_subscriptionEndDate != null)
          Text('Valid until: ${_subscriptionEndDate!.toLocal().toString().split(' ')[0]}'),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSubscriptionButtons() {
    return Column(
      children: [
        _buildSubscriptionButton('Subscribe Monthly', 'monthly', price: 'Rs. 100'),
        SizedBox(height: 8),
        _buildSubscriptionButton('Subscribe Yearly', 'yearly', price: 'Rs. 1,000'),
      ],
    );
  }

  Widget _buildSubscriptionButton(String text, String subscriptionType, {required String price}) {
    return ElevatedButton(
      onPressed: () => _openCheckout(subscriptionType),
      child: Column(
        children: [
          Text(text),
          SizedBox(height: 4),
          Text(price, style: TextStyle(fontSize: 16)),
        ],
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
