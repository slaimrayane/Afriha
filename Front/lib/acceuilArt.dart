// ignore_for_file: no_logic_in_create_state, avoid_print, file_names

import 'package:afriha_app/Classes.dart';
import 'package:afriha_app/ListeInterventions.dart';
import 'package:afriha_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class HomePageArtisan extends StatefulWidget {

  final int color ;

  const HomePageArtisan( {super.key , required this.color });

  @override
  State<HomePageArtisan> createState() => _HomePageArtisanState();

}

class _HomePageArtisanState extends State<HomePageArtisan>{

  Future<void> awaitingNoti() async{
    
    UserData userData = Provider.of<UserData>(context , listen: false);

    List<Notiification> notifications = await fetchNotiForUser() ;

    userData.setNoti(notifications) ;

    setState(() {});
  }

  @override
  void initState() {

    super.initState() ;

    awaitingNoti() ;

  }
  
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(

        backgroundColor: Color(widget.color),

        appBar:ToolBar.topAppBar("Page principale", widget.color , context , awaitingNoti),

        body: SingleChildScrollView(

          child: Container(

            //width: MediaQuery.of(context).size.width * 0., // 30% of the screen width

            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(15),
            //height:144,
            //width: 344,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Color(ToolBar.coulButtonStatic(widget.color)),

              boxShadow:const [BoxShadow(
                color: Color(0x0F000000),
                spreadRadius: 2.0,
                blurRadius: 2.0,
                offset: Offset(3.0, 3.0),
              )],
            ),


            child: Column(

              crossAxisAlignment: CrossAxisAlignment.center,

              children: [

                Image.asset(
                  'Images/Hello Mike.png'
                ),

                const SizedBox(
                  height: 8,
                ),

                const Text(
                  "À La recherche d'une demande ?",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: "Nunito",
                    fontSize: 25,
                    color: Color(0xFF172B4D), // Using the color code 172B4D
                    fontWeight: FontWeight.w800, // Making the text bold
                  ),
                ),

                const SizedBox(height: 10),

                Container(
            
                  width: MediaQuery.of(context).size.width * 0.6, // 30% of the screen width
                  height: MediaQuery.of(context).size.width * 0.6, // 30% of the screen width

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF0075FF),
                      width: 16,
                    ),
                  ),

                  child: Column(

                    mainAxisAlignment: MainAxisAlignment.center,
                    
                    children: [

                      Row(

                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [

                          Text(
                            UserData.artisan.notation.notation.toStringAsFixed(2),

                            style: const TextStyle(
                            fontFamily: "Nunito",
                              fontSize: 50,
                              color: Color(0xFF172B4D), // Using the color code 172B4D
                              fontWeight: FontWeight.w800, // Making the text bold
                            ),
                          ),

                          const Icon(
                            Icons.star,
                            color: Colors.amber ,
                            size: 50,
                          ),

                        ],
                      ),

                      InkWell(

                        onTap:() async{

                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (BuildContext context) => Interventions(artisant: UserData.artisan),
                            )
                          );

                        },

                        child: Text(

                          "${UserData.artisan.notation.nbrNota} interventions",

                          style: TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 14.0 ,
                            color: Colors.black ,
                            fontWeight: FontWeight.w600,
                            shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),

                          ),

                        ),
                      ),
                    ],
                  ),

                ),

                const SizedBox(
                  height: 45,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Flexible(
                      child: Text(
                      
                        UserData.artisan.nomUtilisateur,
                        overflow: TextOverflow.ellipsis,
                      
                        style: const TextStyle(
                              fontFamily: "Nunito",
                          fontSize: 40,
                          fontWeight:FontWeight.bold
                        ),
                      ),
                    ),
                    
                  ],
                ),

                const SizedBox(
                  height: 55,
                ),

                const Row(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(
                      'Votre status',
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 15,
                        color: Color(0xFF172B4D), // Using the color code 172B4D
                        fontWeight: FontWeight.bold, // Making the text bold
                      ),
                    ),

                  ],
                ),

                StatusChanger(status: UserData.artisan.status),

              ]
            ),

          ),
        
        ),
      
        bottomNavigationBar: ToolBar.bottomNavBar(1, widget.color , context),//Voir classe ToolBar
      ),
    );
  }

}

class StatusChanger extends StatefulWidget {

  final bool status;

 const StatusChanger({super.key ,required this.status});
  @override
 
  State<StatusChanger> createState() => _StatusChangerState(light: status);
}

class _StatusChangerState extends State<StatusChanger> {
  
  bool light; 
  _StatusChangerState({required this.light});
  
  @override
  Widget build(BuildContext context) {

    return CupertinoSwitch(
      value: light,

      onChanged: (bool value) {
        setState(() {
          light = value;
          
        });

        if (value) {
          _updateArtisanStatus(UserData.artisan.id,value);
        }else{
          _updateArtisanStatus(UserData.artisan.id,value);
        }
      },
    );
  }
  
  Future<void> _updateArtisanStatus(int id, bool status) async {

    final String url = "http://127.0.0.1:8000/existences/api/artisans/$id/";
    UserData artiData = Provider.of<UserData>(context , listen: false);

    try {

      final response = await http.patch(

        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },

        // Convert the status to JSON format
        body: jsonEncode({
          "status": status,
        }),
        
      );

      print(response.body);
      // Check if the update was successful
      if (response.statusCode == 200) {

        artiData.setStatus(status) ;
        print('Artisan status updated successfully');

      } else {
        // If update fails, throw an exception
        throw Exception('Failed to update artisan status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating artisan status: $error');
    }
  }

}
