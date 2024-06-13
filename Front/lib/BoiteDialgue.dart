// ignore_for_file: file_names

import 'dart:async';

import 'package:afriha_app/Classes.dart';
import 'package:afriha_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoiteDialogueCli extends StatefulWidget {

  final int color ;
  final List<BoiteDialogue> boites ; //son liste des dialogues

  const BoiteDialogueCli({super.key , required this.color , required this.boites});

  @override
  State<BoiteDialogueCli> createState() => _BoiteDialogueCliState();
}

class _BoiteDialogueCliState extends State<BoiteDialogueCli> {

  bool tappedCharge = true ;

  Future<void> awaitingNoti() async{
    UserData userData = Provider.of<UserData>(context , listen: false);

    List<Notiification> notifications = await fetchNotiForUser() ;

    userData.setNoti(notifications) ;

    setState(() {});
  }

  Future<void> awaitingBoites() async{

    UserData userData = Provider.of<UserData>(context , listen: false);
    List<BoiteDialogue> boites = await getDialogues() ;
    userData.setDialogues(boites) ;

    setState(() {});
  }

  @override
  void initState(){

    super.initState() ;

    awaitingNoti() ;
    awaitingBoites();

    Timer(const Duration(milliseconds: 750), () { //petit Timer pour charger bien les notifications avant l'éxécution

      setState(() {
        tappedCharge = false ;
      });

    }); //Timer to wait

  }

  Widget affichageListe(){

    if(widget.boites.isEmpty){
      return Container( //Empty boite de dialogue
          
        padding:const EdgeInsets.symmetric(vertical : 20.0 , horizontal: 20.0),
        margin:const EdgeInsets.fromLTRB(40, 30, 40, 30),
        
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Color(ToolBar.coulButtonStatic(widget.color)),
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
              child: Image.asset("Images/message_empty.png")
            ),

            const SizedBox(height: 20) ,

            const Text(
              "Votre boite de dialogue est vide...",

              textAlign: TextAlign.center,
            
              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w700,
                fontSize: 17.0, 
                color :  Color.fromARGB(255, 1, 33, 80) ,
              ),
            ),

            const SizedBox(height: 40) ,

            const Text(
              "Quand vous confirmez un rendez-vous , ici commence votre conversation avec l'artisant",

              textAlign: TextAlign.center,
            
              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w200,
                fontSize: 15.0, 
                color : Color.fromARGB(255, 1, 33, 80) ,
              ),
            ),

            const SizedBox(height: 20) ,

          ],
        ),
      
      );
    }

    return SingleChildScrollView(
      
      child: Column(
        children: [
      
          const SizedBox(height: 30) ,
      
          Column( //Les artisants concernées
            children: widget.boites.map((boite) =>  boite.itsButton(widget.color, context)).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( //Lmain

      backgroundColor: Color(widget.color),
    
      appBar: ToolBar.topAppBar("Disscussions", widget.color , context , awaitingNoti), //Voir classe ToolBar

      body: tappedCharge ? ToolBar.shortLoadingScreen(color ,0xFFFFFFFF) : affichageListe(), //transition entre loading et affichage

      bottomNavigationBar: ToolBar.bottomNavBar(3, widget.color , context),//Voir classe ToolBar
    
    );
  }
}