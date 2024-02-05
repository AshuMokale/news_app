

import 'package:flutter/material.dart';

class MyLogin extends StatefulWidget{
   const MyLogin({Key? key}) : super(key: key);

  @override
   // ignore: library_private_types_in_public_api
   _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin>{
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration:const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/login.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left:38, top:90),
              child:const Text('Welcome\nPage',
              style: TextStyle(color: Colors.white, fontSize: 35),),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height*0.5,
                  right: 35,
                  left: 35),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                    ),
                    const SizedBox(height: 30,),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('login', style: TextStyle(

                        fontSize: 27, fontWeight: FontWeight.w700),
                      ),

                      ],

                    )
                  ],
                ),

              ),
            )
          ],
        ),
      ),
    );
  }
  }