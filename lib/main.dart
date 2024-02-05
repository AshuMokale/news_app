

import 'package:flutter/material.dart';
import 'package:news_app/login.dart';

import '';
void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
   initialRoute: 'login',
    routes: { 'login': (context)=> MyLogin()},


  ));
}