import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class Splash extends StatefulWidget {

  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {

    super.initState();

    Timer(const Duration(seconds: 4), () {
      // On doit ajouter apres la page suivante.
      Navigator.pushReplacementNamed(context,'/root');
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body:Container(

        decoration: const BoxDecoration(
          color:  Color(0xFF0075FF),
        ),

        width: double.infinity,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset(
              "Images/LOGO.png",
              width:150,
            ),

            const SizedBox(height:20),

            Image.asset(
              "Images/LOGO Name.png",
              width: 300,
            ),

            const SizedBox(height:30),

            const SpinKitFoldingCube(
              color: Colors.white,
            )

          ],

        ),

      ),
    
    );
  }
}
