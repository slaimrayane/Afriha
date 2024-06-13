// ignore_for_file: use_build_context_synchronously, file_names, avoid_print

import 'dart:async';

import 'package:afriha_app/Classes.dart';
import 'package:afriha_app/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;
import 'dart:convert';

class NotationSender extends StatefulWidget {

 final Demande demande ; //cette demande doit avoir tous les attributs non null y compris artisant (Confirmé = true)

  const NotationSender({super.key , required this.demande});

  @override
  State<NotationSender> createState() => _NotationSenderState();
}

class _NotationSenderState extends State<NotationSender> {

  double valNotation = 4 ;
  String commentaire = '' ;

  Future<void> createCommentaire() async {
    
    final String url = 'http://127.0.0.1:8000/existences/api/clients/${UserData.client.id}/demandes/${widget.demande.id}/commentaires/';

    try {

      final response = await http.post(
        Uri.parse(url),

        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },

        body: jsonEncode({

          "commentaire" : commentaire ,
          "notation" : valNotation,

        }),
      );
      
      if (response.statusCode == 201){
        
        print('Notation created successfully');

        sendNotification(widget.demande.artisant!.idUser, "un rendez vous a été fini , le client ${UserData.client.nomUtilisateur} vous a noté $valNotation/5") ;
        sendNotification(UserData.client.idUser, "Vous avez terminé un rendez-vous avec ${widget.demande.artisant!.nomUtilisateur} ") ;

        Navigator.pop(context) ;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:  Text('la notation a été bien envoyé , on vous remercie pour le feedback'),
            duration:  Duration(seconds: 3),
          ),
        );

      } else {
        print('Failed to create NOOTA: ${response.statusCode}');

      }

    } catch (error) {
      print('Error creating Nota: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(color), //transparency to create bubble effect , I think , not yet done

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Container(

            padding:const EdgeInsets.symmetric(vertical : 20.0 , horizontal: 20.0),
            margin:const EdgeInsets.fromLTRB(40, 0, 40, 0),
            
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,

              boxShadow:const [BoxShadow(
                color: Color(0x0F000000),
                spreadRadius: 2.0,
                blurRadius: 2.0,
                offset: Offset(3.0, 3.0),
              )],

            ),

            child: Column(
              
              children: [

                Text( //texto
                  "Votre rendez-vous a été fini avec ${widget.demande.artisant!.nomUtilisateur} d'aprés votre date de demande.\n Veuillez donner une notation et un feedback pour cette artisant : ",
      
                  textAlign: TextAlign.center,

                  style:const TextStyle(
                    fontFamily: "Nunito",
                    fontSize: 17.0,
                    fontWeight: FontWeight.w800,
                    
                  ),
                ),

                const SizedBox(height: 10) ,

                Slider( //simple user friendly inputer

                  value: valNotation,
                  min: 0.0,
                  max: 5.0,
                  divisions: 20,
                  label: valNotation.toStringAsFixed(2),

                  inactiveColor: Colors.black,
                  activeColor: Colors.amber,
                  thumbColor: Colors.amber[400],

                  onChanged: (double value) {
                    setState(() {
                      valNotation = value;
                    });
                  },
                ),

                const SizedBox(height: 10) ,

                TextField( //Descripion

                  minLines: 2,
                  maxLines: 3,
                
                  decoration: InputDecoration(
                
                    hintText: 'Commentaire(facultatif)',
                          
                    hintStyle:const TextStyle(
                      fontFamily: "Nunito" ,
                      fontWeight: FontWeight.w100,
                    ),
                          
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),

                      borderSide:const BorderSide(
                        color: Color(color),
                        width: 2.0 
                      ) ,
                    ),
                  ),
                
                  style:const TextStyle(
                    fontFamily: "Nunito" ,
                    fontWeight: FontWeight.w600,
                    color: Colors.black ,
                  ),
                
                  onChanged: (value) {
                    // Perform search logic here
                    commentaire = value ;
                  },
                
                ),

                const SizedBox(height: 20) ,

                SizedBox(

                  width: 200,

                  child: ElevatedButton(
                  
                    onPressed: () {
                      print("you sent the notation !!!") ;
                      createCommentaire(); 
                    }, 
                  
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0 , vertical: 20.0) ,
                      backgroundColor: Colors.yellow[600],
                      fixedSize: const Size.fromWidth(double.infinity) , 
                    ),
                  
                    child: Text(
                      "Envoyer la notation" ,
                  
                      textAlign: TextAlign.center,
                  
                      style: TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 18.0 ,
                          color: Colors.black ,
                          fontWeight: FontWeight.w600,
                          shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),

                        ),
                  
                    ),
                  ),
                ),

              ],

            ),

          ),
        
    
        ],
      )

    );
  
  }

}