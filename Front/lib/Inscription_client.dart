// ignore_for_file: must_be_immutable, use_build_context_synchronously, avoid_print, file_names

import 'dart:async';
import 'dart:math';

import 'package:afriha_app/Classes.dart';
import 'package:afriha_app/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class InscrireClient extends StatefulWidget {

  const InscrireClient({super.key});

  @override
  State<InscrireClient> createState() => _InscrireClientState();
}

class _InscrireClientState extends State<InscrireClient> {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isvisible = true;
  bool emptyEntries = true ;
  bool tappedLog = false ;

  @override
  void initState(){

    super.initState() ;
    controlEmptiness() ;

  }

  void controlEmptiness(){

    if((usernameController.text.isEmpty || passwordController.text.isEmpty ||  
      telephoneController.text.isEmpty || nomController.text.isEmpty || prenomController.text.isEmpty || 
      emailController.text.isEmpty) && !emptyEntries){

      setState(() {
        emptyEntries = true ;
        print("Empty again");
      });

    }

    if(usernameController.text.isNotEmpty && passwordController.text.isNotEmpty && 
    telephoneController.text.isNotEmpty && nomController.text.isNotEmpty && prenomController.text.isNotEmpty && 
    emailController.text.isNotEmpty && emptyEntries){

      setState(() {
        emptyEntries = false ;
        print("notEmpty");
      });

    }
  }

  Future<void> registerUser() async {

    final url = Uri.parse('http://127.0.0.1:8000/api/auth/register/client/');

    UserData clientData = Provider.of<UserData>(context , listen: false);

    Random random = Random() ;
    int randomSeconds = random.nextInt(2) + 2;
            
    setState(() { //Loading mode
      tappedLog = true ;
    });

    try {

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user': {
            'username': usernameController.text,
            'email': emailController.text,
            'role': "client" ,
            'password': passwordController.text,
          },
          'num_phone': telephoneController.text,
        }),
      );

      if (response.statusCode == 201) {

        // Registration successful

        print('registration posté') ;

        print(response.body) ;

        Map jsonData = jsonDecode(response.body) ;

        Client client = Client(

          id: jsonData["id"] , 
          idUser: jsonData['user']['id'],
          numTel: jsonData['num_phone'],
          nomUtilisateur: jsonData["user"]["username"], 
          compte: jsonData["user"]["email"], 
          imagePath: "Images/20471174.jpg" ,

        );

        clientData.setClient(client) ;

        sendNotification(client.idUser, "Bienvenue dans Afriha , ceci est votre premier pas pour faciliter votre vie !");

        List<Notiification> notis =  await fetchNotiForUser() ;

        clientData.setNoti(notis) ;

        print('User registered successfully!');
        // Navigate to success screen or show success message
         
        Timer( Duration(seconds: randomSeconds), () {

          Navigator.popUntil(context, ModalRoute.withName('')) ; //enlever tous les pages empilées
          Navigator.pushNamed(context,'/homeCli'); //to change page

        });
           
      } else {
        // Registration failed
        print('Failed to register user. Error: ${response.body}');
        // Show error message or handle accordingly
        Timer( Duration(seconds: randomSeconds), () {

          setState(() {
            tappedLog = false ;
          });

          // Handle error, e.g., show error message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:  Text('Authentifucation échouée. Vérifiez vos informations et connexion avant de saisir. Code erreur : ${response.statusCode}'),
              duration:const  Duration(seconds: 3),
            ),
          );

        }); //Timer to wait
      
      }

    } catch (error) {
      // Exception occurred during registration
      print('Error: $error');

      Timer( Duration(seconds: randomSeconds), () {

        setState(() {
          tappedLog = false ;
        });

        // Handle error, e.g., show error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:  Text('Authentifucation échouée. Il a eut une erreur critique , veuillez vérifier vos entrées et connexion'),
            duration:  Duration(seconds: 3),
          ),
        );

      }); //Timer to wait
      
    }
  }

  Widget bodyPageNotCharged(){

    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(

      child: Container(

        margin: EdgeInsets.symmetric( horizontal:width * (10 / 384),vertical: 5),
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            TextField(//Nom

              onChanged: (value) => setState(() {
                controlEmptiness();
              }),

              textAlign: TextAlign.left,
              controller: nomController,

              cursorColor:const Color(0xFF0075FF),

              decoration:InputDecoration(

                hintText: "Nom",

                border:OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
            ),

            const SizedBox(height:8),

            TextField(//Prénom

              onChanged: (value) => setState(() {
                controlEmptiness();
              }),

              textAlign: TextAlign.left,
              controller: prenomController,

              cursorColor:const Color(0xFF0075FF),
              decoration:InputDecoration(

                hintText: "Prénom",

                border:OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
            ),

            const SizedBox(height:8),

            TextField(//Nom de l'utilisateur

              onChanged: (value) => setState(() {
                controlEmptiness();
              }),

              textAlign: TextAlign.left,
              controller: usernameController,

              cursorColor:const Color(0xFF0075FF),
              decoration:InputDecoration(

                hintText: "Nom de l'utilisateur",

                border:OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
            ),

            const SizedBox(height:16),

            TextField(//NumTel

              onChanged: (value) => setState(() {
                controlEmptiness();
              }),

              textAlign: TextAlign.left,
              controller: telephoneController,
              keyboardType: TextInputType.number ,

              cursorColor:const Color(0xFF0075FF),

              decoration:InputDecoration(

                hintText: "Numéro de téléphone",

                border:OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
            ),

            const SizedBox(height: 16),

            TextField(//Email

              onChanged: (value) => setState(() {
                controlEmptiness();
              }),

              textAlign: TextAlign.left,
              controller: emailController,

              cursorColor:const Color(0xFF0075FF),
              decoration:InputDecoration(

                hintText: "Email",

                border:OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
            ),

            const SizedBox(height: 16),

            Column(

              children: [

                TextField(//Mot de Passe

                  onChanged: (value) => setState(() {
                    controlEmptiness();
                  }),

                  textAlign: TextAlign.left,
                  obscureText: isvisible,
                  controller: passwordController,
                  keyboardType:TextInputType.text,
                  cursorColor:const Color(0xFF0075FF),

                  decoration:InputDecoration( 
                    
                    hintText: "Mot de passe",
                    border:OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder:const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF0075FF)),
                    ),

                    hintStyle: const TextStyle(
                      fontFamily: "Nunito",
                      color:Color(0xFF64748B),
                      fontWeight:FontWeight.normal,
                      fontSize:18,
                    ),

                    suffixIcon:IconButton(
                      onPressed:(){
                        setState(() {
                          isvisible = !isvisible;
                        });
                      },
                      icon: Icon(isvisible ? Icons.visibility_off : Icons.visibility),
                    ),

                  ),

                ),

                const SizedBox(height:8),

                RichText(

                  text:TextSpan(
                    style: const TextStyle(
                      fontFamily: "Nunito",
                      color:Colors.black,
                      fontWeight:FontWeight.bold,
                      fontSize:14,
                    ),
                    children:<TextSpan>[

                      const TextSpan(text:"En sélectionnant Accepter et continuer, j'accepte les conditions d'utilisation de " ),
                      TextSpan(
                        text:"Afriha ",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            //navigatorpushnamed
                          },
                        style:const TextStyle(
                          fontFamily: "Nunito",
                          color:Color(0xFF4642FF),
                          decoration:TextDecoration.underline,
                        ),
                      ),

                      const TextSpan(text: ","),

                      TextSpan(
                        text:"les conditions d'utilisation des paiements ",
                        style:const TextStyle(
                          fontFamily: "Nunito",
                          color: Color(0xFF4642FF),
                          decoration:TextDecoration.underline,
                        ) ,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            //navigatorpushanmed
                          }
                      ), 

                      const TextSpan(text: "et "),

                      TextSpan(
                        text: " la politique de notification ",
                        style:const TextStyle(
                          fontFamily: "Nunito",
                          color:Color(0xFF4642FF),
                          decoration:TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            //navigatorpushanmed
                          }
                      ),

                      const TextSpan(text: "et je reconnais "),

                      TextSpan(
                        text: "la politique de confidentialité.",
                        style:const TextStyle(
                          fontFamily: "Nunito",
                          color:Color(0xFF4642FF),
                          decoration:TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            //navigatorpushanmed
                          }

                      )
                    ] ,

                  ),
                
                ),

                const SizedBox(height:8),

                SizedBox(

                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(

                    onPressed:(){
                      
                      if(emptyEntries){

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:  Text('Remplissez tous les entrées avant de valider'),
                            duration:  Duration(seconds: 3),
                          ),
                        );

                      } else {
                        registerUser() ;
                      }

                    },

                    style:ElevatedButton.styleFrom(

                      backgroundColor: emptyEntries ? Colors.blueGrey[50] :const Color(0xFF0075FF),
                      elevation: 0,
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),

                    ),

                    child: Text(

                      "Accepter et continuer",
                        style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight:FontWeight.bold,
                        fontSize:19,
                        color: emptyEntries ? Colors.black : Colors.white,
                        shadows: emptyEntries ? null : List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)) ,
                      ),

                    ),

                  ),

                ),
              ],
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
          "Inscription Client",
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

      body: tappedLog ? ToolBar.shortLoadingScreen(0xFFFFFFFF, 0xFF0075FF) : bodyPageNotCharged(),

    );
  }
}
