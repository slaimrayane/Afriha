// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'Classes.dart';

class PrestCliPage extends StatelessWidget {

  final int color ; //pour Dark/White changement
  final Domaine domaine ; //le domaine cliquée

  const PrestCliPage({super.key , required this.color , required this.domaine});

  List<Prestation> prestList(){
    return domaine.getList() ;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold( //main

      backgroundColor: Color(color) ,

      appBar: AppBar(

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
        
            const SizedBox(width : 20) ,

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
                      'choisir une prestation' ,
                        
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w700,
                        fontSize: 18.0, 
                        color : Colors.white ,
                        shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
                      ),
                        
                    ),
                
                        
                  ],
                ),
              ),
            ),
        
            const SizedBox(width: 70.0) ,
          ],
        ),

        elevation: 0.0 ,
        backgroundColor: Color(ToolBar.coulButtonStatic(color)) , 
        surfaceTintColor: Color(ToolBar.coulButtonStatic(color)),
        titleSpacing: 5.0,
        leading: null,
        automaticallyImplyLeading: false,
      ),
    
      body: ListView(

        children: [ //its elements

          Column( //body that can be scrolled

            children: [

              const SizedBox(height: 10.0) ,

              Container( //Titre + les boutons de prestation
              
                padding:const EdgeInsets.symmetric(vertical : 20.0 , horizontal: 20.0),
                margin:const EdgeInsets.fromLTRB(40, 30, 40, 30),
                
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Color(ToolBar.coulButtonStatic(color)),

                  boxShadow:const [BoxShadow(
                    color: Color(0x0F000000),
                    spreadRadius: 2.0,
                    blurRadius: 2.0,
                    offset: Offset(3.0, 3.0),
                  )],
                ),
              
              
                child: Column(  //Main elements

                  children:[

                    Container(

                      padding:const EdgeInsets.symmetric(vertical : 10.0 , horizontal: 10.0),
                      width: double.infinity,

                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.circular(20.0),
                        color: Color(color) ,

                      ),

                      child: Column(
                        children: [

                          Text( //titre

                            domaine.name ,

                            style: TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w700,
                              fontSize: 22.0, 
                              color : Colors.white ,
                              shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),

                            ),
                                                  
                          ),

                          const SizedBox(height: 10) ,

                          SizedBox( //Image
                            height: 100.0,
                            child: Image.asset(domaine.imgPath),
                          ),

                          const Divider(
                            height: 20 ,
                            indent: 20,
                            endIndent: 20,
                            color: Colors.white,
                          ),

                          const Divider(
                            height: 20 ,
                            indent: 50,
                            endIndent: 50,
                            color: Colors.white,
                          ),

                          const Divider(
                            height: 20 ,
                            indent: 100,
                            endIndent: 100,
                            color: Colors.white,
                          ),

                          const Divider(
                            height: 20 ,
                            indent: 150,
                            endIndent: 150,
                            color: Colors.white,
                          ),

                          Text( //prestation
                            "Choisissez une prestation : " ,
                                                  
                            style: TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w700,
                              fontSize: 20.0, 
                              color : Colors.white ,
                              shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),

                            ),
                                                  
                          ),

                          const SizedBox(height: 10.0),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:  domaine.prestations.map((prestation) => prestation.itsButton(context)).toList() ,
                          )

                        ],
                      ),
                      
                    ),

                  ],
                ),
              ),

            ]
          ),
        ],

      ),

      bottomNavigationBar: ToolBar.bottomNavBar(1, color , context), //See MainToolHelper.dart

    );
  }
}