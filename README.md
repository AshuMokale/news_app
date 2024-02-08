import 'package:flutter/material.dart';

<<<<<<< HEAD
A news app based on Flutter.
=======
void main() {
runApp(MyApp());
}
>>>>>>> 487576aafabd32cb4397e7e5047b4d4381e3b8e0

class MyApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
return MaterialApp(
home: LoginScreen(),
);
}
}

class LoginScreen extends StatelessWidget {
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text('Login'),
),
body: Padding(
padding: EdgeInsets.all(16.0),
child: LoginForm(),
),
);
}
}

class LoginForm extends StatefulWidget {
@override
_LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
final TextEditingController _usernameController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

@override
Widget build(BuildContext context) {
return Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
TextField(
controller: _usernameController,
decoration: InputDecoration(
labelText: 'Username',
),
),
SizedBox(height: 16.0),
TextField(
controller: _passwordController,
obscureText: true,
decoration: InputDecoration(
labelText: 'Password',
),
),
SizedBox(height: 24.0),
ElevatedButton(
onPressed: () {
// TODO: Implement authentication logic
String username = _usernameController.text;
String password = _passwordController.text;
print('Username: $username, Password: $password');
},
child: Text('Login'),
),
],
);
}
}
