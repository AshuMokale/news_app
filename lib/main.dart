import 'package:flutter/material.dart';
import 'package:news_app/Login.dart';
import 'package:news_app/Register.dart';
import 'package:news_app/admin/home.dart';
import 'package:news_app/home.dart';
import 'package:news_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'firebase_options.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
    if (user == null) {
      print('${user!.email} is currently signed out!');
    } else {
      print('${user.email} is signed in!');
    }
  });

  runApp(
    MaterialApp(
    // debugShowCheckedModeBanner: false,
      initialRoute: 'Login',
      routes: {
        'Login': (context) => const MyLogin(),
        'Register': (context) => const MyRegister(),
        'Home':(context) => HomeScreen(),
        'AdminHome': (context) => AdminHome(),
      },
    ),
  );

  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  // Initialize Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();

  Widget _getInitialRoute() {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // If authentication state is loading, display a loading indicator
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            // If user is logged in, navigate to the home screen
            return HomeScreen();
          } else {
            // If user is not logged in, navigate to the login screen
            return MyLogin();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: FutureBuilder(
      //   future: _firebaseInitialization,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return CircularProgressIndicator(); // Display loading indicator while Firebase initializes
      //     } else if (snapshot.hasError) {
      //       return Text('Error initializing Firebase: ${snapshot.error}');
      //     } else {
      //       return MyHomePage();
      //     }
      //   },
      // ),
      home: _getInitialRoute(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to handle anonymous login
  Future<void> _signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User? user = userCredential.user;
      print('Anonymous user signed in: ${user!.uid}');
      // Navigate to next screen or perform any other action
    } catch (e) {
      print('Failed to sign in anonymously: $e');
      // Handle error
    }

  }
  
  Future<void> _signOutUser() async {
    try {
      await _auth.signOut();
      // UserCredential userCredential = await _auth.signOut();
      // User? user = userCredential.user;
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _signInAnonymously,
            child: Text('Sign In Anonymously'),
          ),
          const SizedBox(height: 10,),
          ElevatedButton(
            onPressed: _signOutUser,
            child: Text('Sign Out')
          ),
        ],
      ),
    );
  }
}