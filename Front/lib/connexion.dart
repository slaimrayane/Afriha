// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';
import 'dart:math';

import 'package:afriha_app/Classes.dart';
import 'package:afriha_app/NotValidatedArt.dart';
import 'package:afriha_app/main.dart';
import 'package:afriha_app/notationSetter.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Connexion extends StatefulWidget {
  final int color;

  const Connexion({Key? key, required this.color}) : super(key: key);

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {

  String usernameController = "" ;
  String passwordController = "" ;

  bool emptyEntries = true ;
  bool _obscureText = true;
  bool tappedLog = false ;

  void controlEmptiness(){
    if((usernameController.isEmpty || passwordController.isEmpty) && !emptyEntries){
      setState(() {
        emptyEntries = true ;
      });
    }

    if(usernameController.isNotEmpty && passwordController.isNotEmpty && emptyEntries){
      setState(() {
        emptyEntries = false ;
      });
    }
  }

  List<Demande> listeNota(List<Demande> demandes){ //trouver tous les demandes qu'il faut les noter

    List<Demande> liste = List.empty(growable: true) ;

    for(int i = 0 ; i < demandes.length ; i++){
      
      if(demandes[i].isConfirmed && demandes[i].commentaire == null && demandes[i].dateFin.compareTo(DateTime.now()) < 0){
        liste.add(demandes[i]); 
      }

    }

    return liste ;

  }

  Future<void> authenticateUser(BuildContext context) async {

    const String apiUrl = 'http://127.0.0.1:8000/api/auth/login/';

    UserData userData = Provider.of<UserData>(context , listen: false);

    // Prepare authentication payload
    Map<String, dynamic> payload = {
      "username": usernameController , // Assuming email or username input
      "password": passwordController ,
    };

    Random random = Random() ;
    int randomSeconds = random.nextInt(2) + 2;
            
    setState(() { //Loading mode
      tappedLog = true ;
    });

    try {
      // Send POST request to API
      
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(payload),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      
      if (response.statusCode == 200) {
        // Authentication successful

        Map jsonData = jsonDecode(response.body) ;

        print(jsonData) ;

        switch (jsonData["role"]) { //avoir role de user

          case "client": //c'est un client

            Client client = Client(
              id: jsonData["data"]["id"] , 
              idUser: jsonData["data"]["user"]['id'],
              numTel: jsonData['data']['num_phone'],
              nomUtilisateur: jsonData["data"]["user"]["username"], 
              compte: jsonData["data"]["user"]["email"], 
              imagePath: "Images/20471174.jpg" ,
            );

            userData.setClient(client) ; //notifier les pages à la nouvelle information

            List<Demande> demandes = await fetchDemandesForClient(client) ;

            userData.setList(demandes) ;

            List<BoiteDialogue> dialogues = await getDialogues() ;

            userData.setDialogues(dialogues) ;

            List<Notiification> notis = await fetchNotiForUser() ;

            userData.setNoti(notis) ;

            print("Client connected succufully : ${client.nomUtilisateur}") ;

            List<Demande> liste = listeNota(demandes); //liste des demandes finis confirmé avec rendez vous mais pas commenté

            Timer( Duration(seconds: randomSeconds), () {

              Navigator.popUntil(context, ModalRoute.withName('')) ; //enlever tous les pages empilées
              Navigator.pushNamed(context,'/homeCli'); 

              for(int i = 0 ; i < liste.length ; i++){ //push tous les pages des demandes qui doivent ètre notifié
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (BuildContext context) => NotationSender(demande: liste[i]),
                  )
                );
              }
            
            });


          break;

          case "artisan":

            Artisant artisant = Artisant(
              nomUtilisateur: usernameController , 
              id: jsonData["data"]["id"], 
              idUser: jsonData["data"]["user"]['id'],
              numTel: jsonData['data']['num_phone'],
              compte: jsonData["data"]["user"]["email"],
              status: jsonData['data']['status'],
              imagePath: "Images/20471174.jpg", 
              notation: Notation(notation: jsonData["data"]["notation"], nbrNota: jsonData["data"]['nb_interventions']),
            );

            List<Commentaire> comms = await fetchCommentaireForArtisan(artisant) ;

            artisant.interventions = comms ;

            userData.setArtisant(artisant) ;

            if(jsonData['data']['confirmer']){

              List<Demande> demandes = await fetchDemandesForArtisant(artisant); //demandes à récupérer pour l'artisant

              userData.setList(demandes) ;

              List<BoiteDialogue> dialogues = await getDialogues() ;

              userData.setDialogues(dialogues) ;

              List<Notiification> notis = await fetchNotiForUser() ;

              userData.setNoti(notis) ;

              print("Artisant connected succufully : ${artisant.nomUtilisateur}") ;
              print(dialogues.length);

              Timer( Duration(seconds: randomSeconds), () {

                Navigator.popUntil(context, ModalRoute.withName('')) ; //enlever tous les pages empilées
                Navigator.pushNamed(context,'/homeArti'); 

              });

            } else {

              print("Artisant not official connected , ew: ${artisant.nomUtilisateur}") ;

              Timer( Duration(seconds: randomSeconds), () {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(
                    builder: (BuildContext context) => ApresInscription(isBanned: jsonData['data']['banni']),
                  )
                );
              });

            }



          break;

          default:
            print("unundefined role") ;

            Timer( Duration(seconds: randomSeconds), () {
              Navigator.pushReplacementNamed(context,'/connexion' ); //to change page
          });


        }

        // Handle navigation to the next screen or show success message
      } else {

        Timer( Duration(seconds: randomSeconds), () {

          setState(() {
            tappedLog = false ;
            usernameController = "" ;
            passwordController = "" ;
            controlEmptiness();
          });

          // Handle error, e.g., show error message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:  Text('Connexion échouée. Vérifiez vos informations avant de saisir. Code erreur : ${response.statusCode}'),
              duration:const  Duration(seconds: 3),
            ),
          );

        }); //Timer to wait

        // Authentication failed
        print("Failed to authenticate user. Status code: ${response.statusCode}");

      }
      
    } catch (e) {

      print("Error occurred during authentication: $e");

      Timer( Duration(seconds: randomSeconds), () {

        setState(() {
          tappedLog = false ;
        });

        // Handle error, e.g., show error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:  Text('Error occurred during authentication. Please try again later.'),
            duration:  Duration(seconds: 3),
          ),
        );

      }); //Timer to wait

    }
  }

  Widget bodyPageNotLogged(){

    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(

      child: Container(

        margin:const EdgeInsets.fromLTRB(20, 40, 20, 30),
        
        /*decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(ToolBar.coulButtonStatic(color)),

          boxShadow:const [BoxShadow(
            color: Color(0x0F000000),
            spreadRadius: 2.0,
            blurRadius: 2.0,
            offset: Offset(3.0, 3.0),
          )],
        ),*/

        child: Column(

          children: [

            TextField( //Nom Utilisateur

              onChanged: (value) => setState(() {
                usernameController = value ;
                controlEmptiness();
              }),

              textAlign: TextAlign.left,

              cursorColor:const Color(0xFF0075FF),

              decoration:InputDecoration(

                hintText: "Nom d'utilisateur",

                border:OutlineInputBorder(borderRadius: BorderRadius.circular(15)),

                focusedBorder:const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF0075FF)),
                ),

                hintStyle:const TextStyle(
                  fontFamily: "Nunito",
                  color:Color(0xFF64748B),
                  fontWeight:FontWeight.normal,
                  fontSize:18,
                ),
                
                suffixIcon:const SizedBox.shrink(),
              ),
            
              style: const TextStyle(
                fontFamily: "Nunito",
                fontWeight:FontWeight.w700,
                fontSize:18,
              ),
            
            ),

            const SizedBox(height: 20),
            
            TextField( //mot de passe

              onChanged: (value) => setState(() {
                passwordController = value ;
                controlEmptiness();
              }),

              textAlign: TextAlign.left,

              cursorColor:const Color(0xFF0075FF),
              obscureText: _obscureText,

              decoration:InputDecoration(

                hintText: "Mot de Passe",

                border:OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF0075FF)),
                  borderRadius: BorderRadius.circular(12) ,
                ),

                hintStyle:const TextStyle(
                  fontFamily: "Nunito",
                  color:Color(0xFF64748B),
                  fontWeight:FontWeight.normal,
                  fontSize:18,
                ),
                
                suffixIcon:IconButton(

                  onPressed:(){
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },

                  icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                ),
              ),
            
              style: const TextStyle(
                fontFamily: "Nunito",
                fontWeight:FontWeight.w700,
                fontSize:18,
              ),

            ),

            const SizedBox(height: 100),

            SizedBox(

              width: screenWidth * 0.7314,
            
              child: ElevatedButton(
                
                onPressed: ()  {
            
                  if(emptyEntries){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:  Text('Remplissez tous les entrées avant de valider'),
                        duration:  Duration(seconds: 3),
                      ),
                    );
                  } else {
                    authenticateUser(context);
                  }
            
                },
            
                style: ElevatedButton.styleFrom(
                  backgroundColor: emptyEntries ? Colors.blueGrey[50]  : Colors.blue[600],
                  padding:const EdgeInsets.symmetric(horizontal: 30.0 , vertical: 20.0),
            
                  side:const BorderSide(
                    style: BorderStyle.solid  ,
                    color: Colors.transparent ,
                    width: 4 ,
                  ),
                ),
            
                child: Text(
                  "Se connecter",
                
                  style: TextStyle(
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                    fontSize: 22.0, 
                    color : emptyEntries ? Colors.black : Colors.white,
                    shadows: emptyEntries ? null : List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
                  ),
            
                ),
              ),
            ),
          
          ],
        
        ),
      ),
    );
    
  }


  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Scaffold(

      appBar: AppBar(
        title: Text(
          "Connexion",
          style: TextStyle(

            fontFamily: "Nunito",
            fontWeight: FontWeight.bold,
            fontSize: width * 0.053333,
            letterSpacing: width * (1 / 375),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF1F5F9),
      ),

      body: !tappedLog ? bodyPageNotLogged() : ToolBar.shortLoadingScreen(0xFFFFFFFF, 0xFF0075FF),

    );
  
  }

}
