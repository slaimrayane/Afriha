// ignore_for_file: file_names

import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {

  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();

}

class _FirstPageState extends State<FirstPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(

        child: Column(

          children: [

            Container(

              margin:const EdgeInsets.symmetric(vertical: 50, horizontal: 65),
              child: Column(

                children: [
                  
                  Image.asset("Images/LOGO.png"),
                  Image.asset("Images/LOGOName.png"),

                  const SizedBox(height: 45),
                  const Row(

                    children: [

                      Text(
                        "Bienvenue dans: ",
                        style: TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),

                      Text(
                        "\"Afriha\"",
                        style: TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),


            Container(

              margin:const EdgeInsets.symmetric(vertical: 0, horizontal: 20),

              child: Column(

                children: [

                  const Text(
                    " L’application mobile des services à domicile dans l’Algérie",
                    style: TextStyle(
                      fontFamily: "Nunito",
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 25),

                  SizedBox(//Connexion

                    width: 290,
                    height: 50,

                    child: ElevatedButton(

                      onPressed: () {
                        Navigator.pushNamed(context, "/connexion");
                      },
                      
                      style: ElevatedButton.styleFrom(
                        backgroundColor:const Color(0xFF0075FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      child:const Text(
                        "Se connecter",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Nunito",
                          letterSpacing: 2,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),

                    ),
                  ),
                  
                  const SizedBox(height: 10),

                  SizedBox( //Inscription

                    width: 290,
                    height: 50,

                    child: ElevatedButton(

                      onPressed: () {
                        Navigator.pushNamed(context, "/choixInscr");
                      },
                      
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      child:const Text(
                        "Inscription",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Nunito",
                          letterSpacing: 2,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),

                    ),
                  ),
                  
                  const SizedBox(height: 10),

                  Row(

                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      const Text(
                        "Pour plus de détails , ",
                        style: TextStyle(
                              fontFamily: "Nunito",
                          fontSize:14,
                          fontWeight:FontWeight.normal,
                          color:Colors.grey,
                        ),
                      ),
                      InkWell(

                        onTap: (){
                          //navigator.pushNamed
                        },

                        child:const Text(
                          "cliquez ici",
                          style: TextStyle(

                            fontFamily: "Nunito",
                            fontWeight:FontWeight.bold,
                            color: Color(0xFF0075FF),
                            decoration:TextDecoration.underline,
                            decorationColor: Color(0xFF0075FF),
                            fontSize:14,
                          ),
                        ) ,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}