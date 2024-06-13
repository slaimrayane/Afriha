// ignore_for_file: use_build_context_synchronously, file_names, avoid_print

import 'package:afriha_app/Classes.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProfileEditor extends StatefulWidget {

  final int color ;

  const ProfileEditor({super.key , required this.color});

  @override
  State<ProfileEditor> createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<ProfileEditor> {

  final TextEditingController usernameController = TextEditingController(text: UserData.isClient ? UserData.client.nomUtilisateur : UserData.artisan.nomUtilisateur );
  final TextEditingController emailController = TextEditingController(text: UserData.isClient ? UserData.client.compte : UserData.artisan.compte );



  Future<void> updateUser(int userId) async {

    UserData userData = Provider.of<UserData>(context , listen: false);

    final String apiUrl = 'http://127.0.0.1:8000/api/users/$userId/';
    
    final response = await http.patch(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': emailController.text,
        'username': usernameController.text,
      }),
    );

    if (response.statusCode == 200) {

      print('User updated successfully');
      print(userId);

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content:  Text('données ont été bien sauvegardés'),
          duration:  Duration(seconds: 3),
        ),
      );

      if(UserData.isClient){ //mis à jour dans le front

        UserData.client.compte = emailController.text ;
        UserData.client.nomUtilisateur = usernameController.text ;

        userData.updateRefresh() ;

      }else{

        UserData.artisan.compte = emailController.text ;
        UserData.artisan.nomUtilisateur = usernameController.text ;

        userData.updateRefresh() ;
      }

      Navigator.pop(context) ;
      Navigator.pushReplacementNamed(context, '/photoPro');

    } else {

      Navigator.pop(context) ;

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content:  Text('Vos données saisies sont erronnées , saisissez un nom approprié et email de forme : XXX@XXX.com'),
          duration:  Duration(seconds: 3),
        ),
      );

    }
  }

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

              child: Row(

                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  Text(
                    "Modifier un champs" ,
                      
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
        
            const SizedBox(width: 70.0),
          ],
        ),

        elevation: 0.0 ,
        backgroundColor: Color(widget.color) , 
        surfaceTintColor: Color(widget.color) ,
        titleSpacing: 5.0,
        leading: null,
        automaticallyImplyLeading: false,
      ),
    
      body: SingleChildScrollView(

        child: Container(

          margin: const EdgeInsets.symmetric( horizontal:20,vertical: 5),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(
                "Nom de l'utilisateur : " ,
                  
                style: TextStyle(
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0, 
                  shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
                ),
                  
              ),

              const SizedBox(height:8),

              TextField(//Nom de l'utilisateur

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

              Text(
                "Compte : " ,
                  
                style: TextStyle(
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0, 
                  shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
                ),
                  
              ),

              const SizedBox(height:8),

              TextField(//compte

                textAlign: TextAlign.left,
                controller: emailController,

                cursorColor:const Color(0xFF0075FF),

                decoration:InputDecoration(

                  hintText: "email",

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

              const SizedBox(height:30),

              Center(//save button

                child: SizedBox(

                  width: 200,

                  child: ElevatedButton(
                    
                    onPressed: (){
                      int idUser = UserData.isClient ? UserData.client.idUser : UserData.artisan.idUser ;
                      updateUser(idUser) ;
                    }, 
                  
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0 , vertical: 20.0) ,
                      backgroundColor: Colors.blue[700],
                      fixedSize: const Size.fromWidth(double.infinity) , 
                    ),
                  
                    child: Text( 
                    
                      "Sauvegarder" ,
                            
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 18.0 ,
                        color: Colors.white ,
                        fontWeight: FontWeight.w600,
                        shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),

                      ),
                            
                    ),
                  ),
                ),
              ),
          
            ],

          ),

        ),

      ),


    );
  }
}