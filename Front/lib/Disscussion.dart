// ignore_for_file: file_names, avoid_print

import 'dart:async';

import 'package:afriha_app/Classes.dart';
import 'package:afriha_app/main.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http ;
import 'dart:convert';

import 'package:provider/provider.dart';

class Disscussion extends StatefulWidget {

  final int color ;
  final BoiteDialogue boite ; //son liste des dialogues

  const Disscussion({super.key , required this.color , required this.boite });

  @override
  State<Disscussion> createState() => _DisscussionState();
}

class _DisscussionState extends State<Disscussion> {

  String input = "" ;

  void refresherAPI() async {

    UserData userData = Provider.of<UserData>(context , listen: false);    


    widget.boite.messages = await fetchMessagesForDialogue(widget.boite) ;
    userData.updateRefresh() ;

      
    setState(() {});

    Timer( const Duration(seconds: 2), () {

      if(mounted){

        refresherAPI() ; //pour chaque 2 secondes , on essayera de faire une mis à jour à cette boite de dialogue comme remplacement de API ordinaire
      
      }
    });

    

  }

  void postMessage(String message) async {

    //il faut savoir qui est le sender et qui est le receiver
    int idSender = UserData.isClient ? widget.boite.client.idUser : widget.boite.artisant.idUser ;
    int idReceiver = !UserData.isClient ? widget.boite.client.idUser : widget.boite.artisant.idUser ;

    String url = 'http://127.0.0.1:8000/existences/api/send_message/$idSender/$idReceiver/' ;

    final response = await http.post(
      Uri.parse(url),

      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },

      body: jsonEncode({

        "Message" : message ,

      }),
    );

    if(response.statusCode == 201){

      print('message sent') ;

      Message messageEle = Message(contenu: message, isSender: true) ;

      setState(() {
        widget.boite.addMessage(messageEle) ;  
      });

    }else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load Messages');
    }


  }

  @override
  void initState(){
    super.initState();

    refresherAPI() ;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:const Color(0xFF364077),

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
                      UserData.isClient ? widget.boite.artisant.nomUtilisateur : widget.boite.client.nomUtilisateur ,
                        
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
    
      body: ListView(

        reverse: true, //le scroll commence du bas

        children: [

          Column(
            mainAxisAlignment: MainAxisAlignment.end,

            children: [

              Container( //Introduction
          
                padding:const EdgeInsets.symmetric(vertical:20.0 , horizontal: 20.0),
                margin:const EdgeInsets.fromLTRB(20, 30, 20, 30),
                
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
                      height: 120,
                      child: Image.asset("Images/message_empty.png")
                    ),

                    const SizedBox(height: 20) ,

                    const Text(
                      "Vous pouvez commencer Votre dialogue ici",

                      textAlign: TextAlign.center,
                    
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w700,
                        fontSize: 17.0, 
                        color :  Color.fromARGB(255, 1, 33, 80) ,
                      ),
                    ),

                    const SizedBox(height: 40) ,

                    Text(
                      "Dites Bonjour à ${UserData.isClient ? widget.boite.artisant.nomUtilisateur : widget.boite.client.nomUtilisateur } !",

                      textAlign: TextAlign.center,
                    
                      style:const TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w200,
                        fontSize: 15.0, 
                        color : Color.fromARGB(255, 1, 33, 80) ,
                      ),
                    ),

                    const SizedBox(height: 20) ,

                  ],
                ),
              
              ),

              Column( //Messagerie
                mainAxisAlignment: MainAxisAlignment.end,
                children: widget.boite.messages.map((message) => message.itsWidget()).toList(),
              ),

              const SizedBox(height: 20),

            ],
          ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(

        height: 75 ,

        color: Colors.grey[100],
        surfaceTintColor: Colors.grey[100],

        child: Row(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Expanded( //Text+Send

              child: TextField( 
                
                decoration: InputDecoration(
              
                  hintText: 'Envoyez un message...',
                        
                  hintStyle:const TextStyle(
                    fontFamily: "Nunito" ,
                    fontWeight: FontWeight.w100,
                  ),
                  
                  suffixIcon: IconButton(
                  
                    onPressed:() {
                  
                      if (input.isNotEmpty) {
                        postMessage(input) ;
                      }
                  
                    },
                  
                    icon: Icon(
                      Icons.send,
                  
                      color: Colors.blue[700],
                    ),
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                      color: Color(widget.color),
                      width: 2.0 
                    ) ,
                  ),

                ),
              
                style: TextStyle(
                  fontFamily: "Nunito" ,
                  fontWeight: FontWeight.w600,
                  color: Color(ToolBar.coulTextStatic(widget.color)) ,
                ),
              
                onChanged: (value) => input = value , //pour fonctionner le bouton envoyer

                onSubmitted: (value) {
                  postMessage(value) ;
                },
              
              ),
            ),

            const SizedBox(width: 10) ,

          ],

        ),
      ),
      
    );
  }
}