

import 'package:flutter/material.dart';
import 'package:news_app/Register.dart';
import 'package:news_app/login.dart';


void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
   initialRoute: 'login',
    routes: {
      'login': (context)=> const MyLogin(),
      'Register': (context)=> const MyRegister(),
    },


//<<<<<<< HEAD
  ));
}
=======
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                // Implement your authentication logic here
                String username = _usernameController.text;
                String password = _passwordController.text;

                // For simplicity, we are just printing the entered credentials
                print('Username: $username, Password: $password');
              },
              child: Text('login'),
            ),
          ],
        ),
      ),
    );
  }
}
>>>>>>> a2beed23053d176a351afbf9a78f9ac7bcdb8ec4
