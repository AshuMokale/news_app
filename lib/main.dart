

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


  ));
}