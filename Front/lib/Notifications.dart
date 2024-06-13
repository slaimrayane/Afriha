// ignore_for_file: use_build_context_synchronously, file_names

import 'dart:async';

import 'package:afriha_app/Classes.dart' ;
import 'package:afriha_app/main.dart';
import 'package:flutter/material.dart' ;

class NotificationsPage extends StatefulWidget {

  final Future<void> Function() refreshLastPage ;

  const NotificationsPage({super.key , required this.refreshLastPage});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  bool tappedCharge = true ;

  @override
  void initState() {

    super.initState() ;

    patchVueNotis() ;
    
    Timer(const Duration(milliseconds: 750), () { //petit Timer pour charger bien les notifications avant l'éxécution

      setState(() {
        tappedCharge = false ;
      });

    }); //Timer to wait

  }
  
  Widget affichageList(){

    List<Notiification> notifications = UserData.notifications ;

    if(notifications.isEmpty){

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
          
        child: Column(

          children: [

            SizedBox( //NotFound Image
              height: 180,
              child: Image.asset("Images/Notification_empty.png")
            ),

            const SizedBox(height: 20) ,

            const Text(

              "Vous n'avez reçu aucune notification , veuillez attendre qu'un évènement atteind à votre l'application pour ouvrir cette page",

              textAlign: TextAlign.center,
            
              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w700,
                fontSize: 17.0, 
                color : Color.fromARGB(255, 1, 33, 80) ,
              ),
            ),

            const SizedBox(height: 40) ,

          ],
        ),
      
      );
    
    }

    return SingleChildScrollView(

      child: Column(

        children: [

          const SizedBox(height: 20) ,
      
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: notifications.map((intervention) => intervention.itsWidget(color, context)).toList() ,
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
                  
              onPressed: () async{

                await widget.refreshLastPage() ; //appeler la fonction assez tard de fetch notifications dans avant dernière page pour l'icon change sur le background sans modifier nouvelle notification de cette page
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
                      "Notifications" ,
                        
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