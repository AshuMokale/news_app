
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyLogin extends StatefulWidget{
  const MyLogin({Key? key}) : super(key: key);

  @override
   _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin>{
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
        image:DecorationImage(
          image: AssetImage('assets/login.png'), fit: BoxFit.cover),
      ),
    );
  }
  }