// ignore_for_file: file_names, avoid_print

import 'dart:async';
import 'dart:math';

import 'package:afriha_app/Classes.dart';
import 'package:afriha_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListArtisant extends StatefulWidget {

  final int color ;
  final List<Artisant> artisants ;
  final Demande demande ;

  const ListArtisant({super.key , required this.artisants , required this.demande, required this.color});

  @override
  State<ListArtisant> createState() => _ListArtisantState();
}

class _ListArtisantState extends State<ListArtisant> {

  bool tappedCharge = false ;

  Future<void> confirmerRDV(Artisant artisant , BuildContext context) async { //Confirmer un rendez vous avec un artisant

    UserData cliData = Provider.of<UserData>(context , listen: false);
    
    final String url = 'http://127.0.0.1:8000/existences/api/clients/${UserData.client.id}/demandes/${widget.demande.id}/confirmer/${artisant.id}';

    Random random = Random() ;
    int randomSeconds = random.nextInt(2) + 1;

    setState(() { //Loading mode
      tappedCharge = true ;
    });


    try {

      final response = await http.patch( //modifier la bdd demande pour notifier qu'elle est confirmé
        Uri.parse(url),

        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },

        body: jsonEncode({
          "Confirme" : true ,
          "artisan" : artisant.id ,
        }),

      );
      
      if (response.statusCode == 200){
        
        print('Demande confirmed successfully');

        sendNotification(UserData.client.idUser , "Vous avez confirmé un rendez-vous avec ${artisant.nomUtilisateur} , vérifiez votre boite de dialogues") ;

        List<int> ids = widget.demande.artisants.map((e) => e.idUser).toList() ;

        for (var idUser in ids) {

          idUser == artisant.idUser ? sendNotification(idUser, "${UserData.client.nomUtilisateur} a confirmé un rendez-vous avec vous") :
          sendNotification(idUser, "${UserData.client.nomUtilisateur} a déja confirmé un rendez-vous avec un autre artisant , votre invitation a été échoué");

        }

        List<Demande> demandes = await fetchDemandesForClient(UserData.client) ; //rafraishir la nouvelle liste pour l'artisant

        cliData.setList(demandes) ;

        Timer( Duration(seconds: randomSeconds), () {

          Navigator.popUntil(context, ModalRoute.withName('')) ;
          Navigator.pushNamed(context, "/demandeCli") ;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:  Text('Vous avez confirmé un rendez vous, veuillez vérifier votre boite de disscussion'),
              duration:  Duration(seconds: 3),
            ),
          );

        });

      } else {

        print('Failed to confirm Demande: ${response.statusCode}');

        Timer( Duration(seconds: randomSeconds), () {

          setState(() {
            tappedCharge = false ;
          });

          // Handle error, e.g., show error message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:  Text('Confirmation échoué , un problème a été survenue , veuillez réssayer ultérieurement.Code erreur : ${response.statusCode}'),
              duration:const  Duration(seconds: 3),
            ),
          );
        }); //Timer to wait

      }

    } catch (error) {
      print('Error confirming Demande: $error');
    }
  }

  Widget affichageListe(){ //Gérer affichage principale de la liste des artisants

    if(widget.artisants.isEmpty){ //Pas artisants qui ont acceptés cette demande

      return Container( //Empty list affichage
          
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

            SizedBox( //Empty List Image
              height: 180,
              child: Image.asset("Images/List_empty.png")
            ),

            const SizedBox(height: 20) ,

            const Text(
              "Aucun artisant a accepté pour le moment...",

              textAlign: TextAlign.center,
            
              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w700,
                fontSize: 17.0, 
                color : Color.fromARGB(255, 1, 33, 80) ,
              ),
            ),

            const SizedBox(height: 40) ,

            const Text(
              "Vous devez attendre qu'au moins un artisant accepte votre demande",

              textAlign: TextAlign.center,
            
              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w200,
                fontSize: 15.0, 
                color :Color.fromARGB(255, 1, 33, 80) ,
              ),
            ),

            const SizedBox(height: 20) ,

          ],
        ),
      
      );
    
    }

    return Column(

      children: [
        
        Container(
        
          padding:const EdgeInsets.symmetric(vertical : 20.0 , horizontal: 20.0),
          margin:const EdgeInsets.fromLTRB(40, 30, 40, 30),
          
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.0),
            color: Color(ToolBar.coulButtonStatic(widget.color)),
            boxShadow:const [BoxShadow(
              color: Color(0x0F000000),
              spreadRadius: 2.0,
              offset: Offset(2.0, 2.0),
            )],
          ),
        
          child: Center(
            child: Text( //nom
              "Confirmez l'un de ces artisants pour commencer un rendez-vous :",
                  
              textAlign: TextAlign.center,

              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w600,
                fontSize: 16.0, 
                color : Color(ToolBar.coulTextStatic(widget.color)) ,
              ),
              
            ),
          ),
        ),

        const SizedBox(height : 10) ,

        Column( //The list
          children: widget.artisants.map((artisant) => artisant.rowElementDemande(widget.color, context , confirmerRDV)).toList(),
        ),
        
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold( //Lmain

      backgroundColor: Color(widget.color) ,
    
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
                  color: Color(widget.color),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                        
                  children: [
                        
                    Text(
                      "liste des artisants" ,
                        
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
        backgroundColor: Color(ToolBar.coulButtonStatic(widget.color)) , 
        surfaceTintColor: Color(ToolBar.coulButtonStatic(widget.color)) ,
        titleSpacing: 5.0,
        leading: null,
        automaticallyImplyLeading: false,
      ),
    
      body:tappedCharge ? ToolBar.shortLoadingScreen(widget.color ,0xFFFFFFFF) : ListView( //ListView means the content can be scrolled

        children: [
          affichageListe(),
        ],
      ),

      bottomNavigationBar: ToolBar.bottomNavBar(2, widget.color , context),//Voir classe ToolBar
    );
  
  }
}