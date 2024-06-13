// ignore_for_file: file_names

import 'package:afriha_app/Classes.dart';
import 'package:flutter/material.dart';


class ChoixInscription extends StatelessWidget {

  final int color ;

  const ChoixInscription({super.key , required this.color});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar( //la barre de lfou9

        toolbarHeight: 45,
      
        title: Row(

          mainAxisAlignment: MainAxisAlignment.start,
        
          children: [
        
            IconButton( //Return Button
                  
              onPressed: () {
                Navigator.pop(context) ;
              },
        
              style : ElevatedButton.styleFrom(
                padding:const EdgeInsets.all(0.0),
                elevation: 0.0 ,
              ),
                
              icon:Image.asset(
                "Images/chevron-left.png",
                width: 20,
                height: 20,
              ),
        
            ),

            const SizedBox(width: 20.0),
        
            Expanded( //on prend le reste de l'espace au milieu

              child: Container(

                padding: const EdgeInsets.symmetric(horizontal: 5 , vertical: 3),
                margin: const EdgeInsets.symmetric(horizontal: 5 , vertical: 5),
          
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Color(color),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                        
                  children: [
                        
                    Text(
                      "Inscription" ,
                        
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0, 
                        color : Colors.white ,
                        shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
                      ),
                        
                    ),
                        
                  ],
                ),
              ),
            ),
        
            const SizedBox(width: 70.0),
          ],
        ),

        elevation: 0.0 ,
        backgroundColor: Color(ToolBar.coulButtonStatic(color)) , 
        surfaceTintColor: Color(ToolBar.coulButtonStatic(color)) ,
        titleSpacing: 5.0,
        leading: null,
        automaticallyImplyLeading: false,
      ),
    
      body:Container(

        decoration: BoxDecoration(
          color:  Color(color),
        ),

        width: double.infinity,

        child: Column( //Texte + button1 + button2
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(//Button de client

              padding:const EdgeInsets.symmetric(vertical : 20.0 , horizontal: 20.0),
              margin:const EdgeInsets.symmetric(vertical: 30 , horizontal: 30),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Color(ToolBar.coulButtonStatic(color)),
                boxShadow:const [BoxShadow(
                  color: Color(0x0F000000),
                  spreadRadius: 2.0,
                  offset: Offset(2.0, 2.0),
                )],
              ),

              child: Container(

                padding:const EdgeInsets.symmetric(vertical : 40.0 , horizontal: 20.0),
                width: double.infinity,

                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(20.0),
                  color: Color(color) ,

                ),

                child: Column(
                
                  children: [
                
                    Text(
                     "Voulez vous s'inscrire en tant que:" ,
                
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w800,
                        fontSize: 22.0, 
                        color : Colors.white ,
                        shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
                        
                      ),
                
                      textAlign: TextAlign.center,
                    ),
                
                    const SizedBox(height: 20.0),
                
                    ElevatedButton( //Button Client
                      onPressed: () {
                        Navigator.pushNamed(context, "/inscriptionCli") ;
                      }, 
                    
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0 , vertical: 20.0) ,
                        backgroundColor: Colors.white,
                        fixedSize: const Size.fromWidth(double.infinity) , 
                      ),
                    
                      child: Text(
                        "Client" ,
                    
                        style: TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 18.0 ,
                          color: Colors.black ,
                          fontWeight: FontWeight.w600,
                          shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),

                        ),
                    
                      ),
                    ),
                    
                    const SizedBox(height:10.0),
                
                    Text(//OR
                     "Ou bien:" ,
                
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w800,
                        fontSize: 22.0, 
                        color : Colors.white ,
                        shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
                        
                      ),
                    ),
                
                    const SizedBox(height:10.0),
                
                    ElevatedButton( //Button Artisant
                      onPressed: () {
                        Navigator.pushNamed(context, "/inscriptionArti") ;
                      }, 
                    
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0 , vertical: 20.0) ,
                        backgroundColor: Colors.white,
                        fixedSize: const Size.fromWidth(double.infinity) , 
                      ),
                    
                      child: Text(
                        "Artisan" ,
                    
                        style: TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 18.0 ,
                          color: Colors.black ,
                          fontWeight: FontWeight.w600,
                          shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),

                        ),
                    
                      ),
                    ),
                
                  ],
                ),
              ),

            ),

          ],

        ),

      ),
    );
  }
}
