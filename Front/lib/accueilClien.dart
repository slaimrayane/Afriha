// ignore_for_file: file_names

import 'package:afriha_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Classes.dart';

class HomePageClient extends StatefulWidget {

  final int color ;
  final List<Domaine> domaines ; 

  const HomePageClient({super.key , required this.color , required this.domaines});

  @override
  State<HomePageClient> createState() => _HomePageClientState();
}

class _HomePageClientState extends State<HomePageClient> {

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

  List<Widget> listRows(BuildContext context){ //retourne une liste de lignes de deux boutons chacune

    print("here") ;
    List<Widget> listeChildren = List.empty(growable: true);

    for(int i = 0 ; i < widget.domaines.length ; i+=2) {

      if(i >= widget.domaines.length - 1){ //il a resté juste un seul élément

        listeChildren.add(
          Row( //une seule ligne avec un seul bouton
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              widget.domaines[i].itsWidget(context) ,
            ],
        ));

      } else {

        listeChildren.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
              //ici pour chaque domaine , on prend sa méthode itsWidget et l'afficher
            children: widget.domaines.sublist(i , i+2).map((domaine) => domaine.itsWidget(context)).toList(), 
        ));
        
      }

    }

    print("here ?") ;
    return listeChildren ;

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold( //Lmain

      backgroundColor: Color(widget.color),
    
      appBar: ToolBar.topAppBar("lancer une demande", widget.color , context , awaitingNoti), //Voir classe ToolBar

      body: ListView( //ListView means the content can be scrolled

        children: [ //its elements

          Column( //Column of Two main Objects

            children: [

              Container( //The domains
              
                padding:const EdgeInsets.symmetric(vertical : 20.0 , horizontal: 20.0),
                margin:const EdgeInsets.all(30),
                
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
              
              
                child: Column( //Li 7a ykoune tani Column de texte 
                  children: [

                    const Text(
                      "Choisissez un domaine pour créer une demande : ",
          
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                        
                      ),
                    ),
          
                    const SizedBox(height: 5.0),

                    Column( 
                      children: listRows(context) , //methode appélée va diviser les boutons à une matrice de 2 par deux chaque ligne
                    ),

                  ],
                ),
              ),
          
              const SizedBox(height: 30.0),

            ],
          ),
        ],
      ),

      bottomNavigationBar: ToolBar.bottomNavBar(1, widget.color , context),//Voir classe ToolBar
    );
  }
}