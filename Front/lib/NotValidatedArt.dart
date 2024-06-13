
// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ApresInscription extends StatelessWidget {

  final bool isBanned ; //si la cause est le banne ou pas
  
  const ApresInscription({super.key , required this.isBanned});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar:AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon:const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.white,
      ),
      
      backgroundColor: const Color(0xFFFCF8F8),
      
      body:SafeArea(

        child: Center(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            margin:const EdgeInsets.fromLTRB(16, 55, 16, 90),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300]!,
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset:const Offset(-1, 6)
                ),
              ],
            ),

            child:Column(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                SizedBox(
                  width: 200,
                  child: Image.asset(isBanned ?  "Images/User_Banned.png" :  "Images/Component13.png"),
                ),

                const SizedBox(height:8),

                Text(
                  isBanned ? 
                  "Oops..." :
                  "Bienvenue",
                  style:const TextStyle(
                    fontFamily: "Nunito",
                    color:Colors.black,
                    fontWeight:FontWeight.bold,
                    fontSize:20,
                  ),
                ),

                const SizedBox(height: 10),
                
                Text(

                  isBanned ?
                  "Il semble que vous avez été banni par l'administrateur , pour plus d'informations , contactez le service Afriha d'administration" :
                  "Aprés avoir déja inscrit , Vous serez notifié une fois que les administrateurs auront accepté votre demande , veuillez revenir plus tard :)",
                  
                  style:const TextStyle(
                    fontFamily: "Nunito",
                    fontWeight:FontWeight.normal,
                    fontSize:14,
                    color:Color(0xFF535763),
                  ),
                  textAlign: TextAlign.center,
                ),

              ],
            ) ,
          ),
        ),
      ) ,
    ) ;
  }
}