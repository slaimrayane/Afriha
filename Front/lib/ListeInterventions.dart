// ignore_for_file: file_names

import 'dart:async';

import 'package:afriha_app/Classes.dart';
import 'package:afriha_app/main.dart';
import 'package:flutter/material.dart';

class Interventions extends StatefulWidget {//page des interventions d'un artisan

  final Artisant artisant ;

  const Interventions({super.key , required this.artisant});

  @override
  State<Interventions> createState() => _InterventionsState();
}

class _InterventionsState extends State<Interventions> {

  bool tappedCharge = true ;

  @override
  void initState(){

    super.initState() ;
    
    Timer(const Duration(milliseconds: 750), () {

      setState(() {
        tappedCharge = false ;
      });

    }); //Timer to wait

  }

  Widget affichageList(){

    List<Commentaire> listInterventions = widget.artisant.interventions ;

    if(listInterventions.isEmpty){

      return Container( //Empty list affichage
          
        padding:const EdgeInsets.symmetric(vertical : 20.0 , horizontal: 20.0),
        margin:const EdgeInsets.fromLTRB(40, 30, 40, 30),
        
        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(20.0),
          color: Color(ToolBar.coulButtonStatic(color)),
          boxShadow:const [BoxShadow(
            color: Color(0x0F000000),
            spreadRadius: 2.0,
            offset: Offset(2.0, 2.0),
          )],

        ),
          
        child: SingleChildScrollView(
          
          child: Column(
          
            children: [
          
              SizedBox( //NotFound Image
                height: 180,
                child: Image.asset("Images/List_empty.png")
              ),
          
              const SizedBox(height: 20) ,
          
              Text(
          
                UserData.isClient ? "Aucune interventions fait par l'artisan ${widget.artisant.nomUtilisateur}" :
                "Vous n'avez fait aucune interventions , vous pouvez les consulter aprés avoir terminer un rendez-vous",
          
                textAlign: TextAlign.center,
              
                style:const TextStyle(
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w700,
                  fontSize: 17.0, 
                  color : Color.fromARGB(255, 1, 33, 80) ,
                ),
              ),
          
              const SizedBox(height: 40) ,
          
            ],
          ),
        ),
      
      );
    
    }

    return SingleChildScrollView(
      
      child: Column(
        children: [
      
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: listInterventions.map((intervention) => intervention.itsWidget()).toList() ,
          ),
      
         const SizedBox(height: 20) ,
        ],
      ),
    ) ;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor:const Color(color),

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
                  color:const Color(color),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                        
                  children: [
                        
                    Text(
                      "Liste d'interventions" ,
                        
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
    
      body: tappedCharge ? ToolBar.shortLoadingScreen(color ,0xFFFFFFFF) : affichageList(),

    );
  }
}