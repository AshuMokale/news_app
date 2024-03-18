import 'package:flutter/material.dart';
import 'package:news_app/Login.dart';
import 'package:news_app/Register.dart';
import 'package:news_app/home.dart';
import 'package:news_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      },
    ),
  );

  runApp(MyApp());
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
          return const CircularProgressIndicator();
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