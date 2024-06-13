// ignore_for_file: file_names, avoid_print

import 'dart:async' ;
import 'dart:math' ;
import 'package:http/http.dart' as http ;
import 'dart:convert' ;

import 'package:afriha_app/Classes.dart';
import 'package:afriha_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListeDemande extends StatefulWidget {

  final int color ;

  const ListeDemande({super.key  , required this.color });

  @override
  State<ListeDemande> createState() => _ListeDemandeState();
}

class _ListeDemandeState extends State<ListeDemande> {

  List<Demande> demandesAttente = List.empty(growable: true); //liste de demande en attente
  List<Demande> historiqueDem = List.empty(growable: true); //liste des historiques
  List<Demande> demandesConfir = List.empty(growable: true); //liste des demandes confirmés

  String selectedChoice = "Demandes en cours" ;

  List<String> listeStr = UserData.isClient ? ["Demandes en cours" , "historique des demandes finies" , "Vos rendez-vous"] : ['Demandes en cours' , "demandes acceptés non confirmés" , "Vos rendez-vous"];

  bool tappedCharge = true ;
  bool isAttentePage = true ;
  bool isRdvPage = false ;

  Future<void> createDemandAcceptee(Demande demande , BuildContext context) async {

    Random random = Random() ;
    int randomSeconds = random.nextInt(3) + 1;

    setState(() { //Loading mode
      tappedCharge = true ;
    });


    UserData artiData = Provider.of<UserData>(context , listen: false);
    
    final String url = 'http://127.0.0.1:8000/existences/api/artisans/${UserData.artisan.id}/demandes/${demande.id}/';

    try {

      final response = await http.post(
        Uri.parse(url),

        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },

        body: jsonEncode({

          "demande_id" : demande.id ,
          "artisan_id" : UserData.artisan.id,

        }),
      );
      
      if (response.statusCode == 201){
        
        print('Demande accepted successfully');
        
        List<Demande> demandes = await fetchDemandesForArtisant(UserData.artisan) ; //rafraishir la nouvelle liste pour l'artisant

        artiData.setList(demandes) ;

        Timer( Duration(seconds: randomSeconds), () {

          setState(() {
            tappedCharge = false ;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:  Text('Vous avez accepté une demande , vous pouvez ajouter d\'autre ou bien attendre une confirmation du client'),
              duration:  Duration(seconds: 4),
            ),
          );

        });


      } else {
        print('Failed to accept Demande: ${response.statusCode}');
        
        Timer( Duration(seconds: randomSeconds), () {

          setState(() {
            tappedCharge = false ;
          });

          // Handle error, e.g., show error message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:  Text('Demande échoué , un problème a été survenue , veuillez réssayer ultérieurement.Code erreur : ${response.statusCode}'),
              duration:const  Duration(seconds: 3),
            ),
          );
        }); //Timer to wait

      }

    } catch (error) {
      print('Error accepting Demande: $error');
    }
  }

  void filterList(){ //filtrer les listes soit d'aprés le client ou bien l'artisant

    demandesAttente = List.empty(growable: true);//liste des demandes qui sont en attente d'une action
    historiqueDem = List.empty(growable: true); //liste des demandes anciennes pour client / accepté par l'artisant
    demandesConfir = List.empty(growable: true); //liste des demandes confirmés donc rendez vous

    for(int i = 0 ; i < UserData.demandes.length ; i++){

      if(UserData.isClient){

        if(UserData.demandes[i].isFinished()){

          historiqueDem.add(UserData.demandes[i]);

        }else if(UserData.demandes[i].isConfirmed){

          demandesConfir.add(UserData.demandes[i]);

        }else{

          demandesAttente.add(UserData.demandes[i]);

        }

      } else {

        if(!UserData.demandes[i].isFinished()){

          if(UserData.demandes[i].isConfirmed){

            demandesConfir.add(UserData.demandes[i]);

          }else if(UserData.demandes[i].contains(UserData.artisan)){

            historiqueDem.add(UserData.demandes[i]);

          }else{

            demandesAttente.add(UserData.demandes[i]);

          }

        }

      }

    }
  }

  Widget affichageListe(bool isAttente , bool isRDV){ //Gérer l'affichage principale de cette page

    List<Demande> demandes = isRDV ? demandesConfir : (isAttente ? demandesAttente : historiqueDem );

    if(demandes.isEmpty){

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

            SizedBox( //NotFound Image
              height: 180,
              child: Image.asset("Images/List_empty.png")
            ),

            const SizedBox(height: 20) ,

            Text(

              isRDV ? "Aucun rendez vous confirmé pour le moment..." :  (isAttente ?
              "Aucune demande en cours pour le moment..."
              : "Aucune demande fini pour le moment..."),

              textAlign: TextAlign.center,
            
              style:const TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w700,
                fontSize: 17.0, 
                color : Color.fromARGB(255, 1, 33, 80) ,
              ),
            ),

            const SizedBox(height: 40) ,

            Text(

              !isAttentePage ? '' : 
                (UserData.isClient ? 
                "Ajoutez une demande avant de consulter un artisant puis faire un rendez vous :" : 
              "Attendez un client crée une demande pour que vous puissiez l'accepeter"),

              textAlign: TextAlign.center,
            
              style:const  TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w200,
                fontSize: 15.0, 
                color : Color.fromARGB(255, 1, 33, 80) ,
              ),
            ),

            const SizedBox(height: 20) ,

            isAttentePage && UserData.isClient ? Center(

              child: ElevatedButton( //GoHome Button

                onPressed: (){
                  
                  Navigator.popUntil(context, ModalRoute.withName('')) ;
                  Navigator.pushNamed(context, '/homeCli') ;

                },
              
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0 , vertical: 20.0) ,
                  backgroundColor: Colors.blue[600],
                  fixedSize: const Size.fromWidth(double.infinity) , 
                ),
              
                child: Row(

                  children: [

                    const SizedBox(width: 10) ,

                    const Icon(

                      Icons.playlist_add ,
                      color: Colors.white,

                    ),

                    const SizedBox(width: 10),

                    Text(

                      "Ajouter une demande" ,
                    
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 16.0 ,
                        color: Colors.white ,
                        fontWeight: FontWeight.w600,
                        shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),

                      ),
                                  
                    ),
                  ],
                ),
              ),
            ) : const SizedBox(height: 0),

          ],
        ),
      
      );
    
    }

    return Column(
      children: [

        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: demandes.map((demande) => UserData.isClient ? demande.itsWidgetForClient(color , context) : demande.itsWidgetForArtisant(color, context , createDemandAcceptee)).toList() ,
        ),

       const SizedBox(height: 20) ,
      ],
    ) ;
  }

  Future<void> awaitingNoti() async{
    UserData userData = Provider.of<UserData>(context , listen: false);

    List<Notiification> notifications = await fetchNotiForUser() ;

    userData.setNoti(notifications) ;

    setState(() {});
  }

  Future<void> awaitingDemande() async{

    UserData userData = Provider.of<UserData>(context , listen: false);

    List<Demande> demandes = UserData.isClient ? await fetchDemandesForClient(UserData.client) : await fetchDemandesForArtisant(UserData.artisan) ;

    userData.setList(demandes) ;

    setState(() {});
  }

  @override
  void initState(){

    super.initState() ;

    awaitingNoti() ;
    awaitingDemande() ;
    
    Timer(const Duration(seconds: 2), () {

      setState(() {
        tappedCharge = false ;
      });

    }); //Timer to wait

  }

  @override
  Widget build(BuildContext context) {

    filterList() ;

    return Scaffold( //Lmain

      backgroundColor: Color(widget.color) ,
    
      appBar: ToolBar.topAppBar("liste demandes", color, context , awaitingNoti),

      body: tappedCharge ? ToolBar.shortLoadingScreen(widget.color ,0xFFFFFFFF) : SingleChildScrollView( //ListView means the content can be scrolled

        child: Column(
          children: [  
            
            Container(

              padding:const EdgeInsets.symmetric(vertical : 20.0 , horizontal: 20.0),
              margin:const EdgeInsets.fromLTRB(40, 30, 40, 30),

              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(22.0),

                color: Colors.white,

                boxShadow:const [BoxShadow(
                  color: Color(0x0F000000),
                  spreadRadius: 2.0,
                  offset: Offset(2.0, 2.0),
                )],

              ),

              child: Column(

                children: [

                  Text(

                    UserData.isClient ? 
                    "Révisez vos demandes et listez soit vos anciennes demandes , les demandes en cours , ou bien vos rendez-vous :" :
                    "Consultez les demandes ou bien révisez cels que vous avez accepté , vous pouvez aussi lister vos propres rendez-vous :" ,

                    textAlign: TextAlign.center,      
                    style: TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w700,
                      fontSize: 14.0, 
                      color : Color(ToolBar.coulTextStatic(color)) ,
                    ),
                                          
                  ),

                  const SizedBox(height: 10) ,

                  Container(

                    padding:const EdgeInsets.symmetric(horizontal: 10),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(widget.color).withOpacity(0.4),
                    ),

                    child: DropdownButton<String>(
                                  
                      isExpanded: true,
                      value: selectedChoice,
                    
                      iconEnabledColor: Color(widget.color).withOpacity(0.5),
                                  
                      onChanged: (String? value) {
                                  
                        setState(() {
                          tappedCharge = true ;
                          selectedChoice=value!;

                          Timer(const Duration(seconds: 1), () {

                            setState(() {
                              tappedCharge = false ;
                            });

                          }); //Timer to wait
                                  
                        });
                      },
                                  
                      items: listeStr.map((demande) {
                                  
                        return DropdownMenuItem<String>(
                                  
                          value: demande,

                          alignment: Alignment.center,

                          child: Text(
                            demande,
                            style:const TextStyle(
                              color: Colors.black ,
                            ),
                          ),
                                  
                          onTap: () { //changer mode de demandes
                                  
                            if(demande.contains("cours")){
                              isAttentePage = true ;
                              isRdvPage = false ;
                            } else if(demande.contains("rendez")){
                              isAttentePage = false ;
                              isRdvPage = true ;
                            } else {
                              isAttentePage = false ;
                              isRdvPage = false ;
                            }
                                  
                            setState(() {

                              tappedCharge = true ;
                              Timer(const Duration(seconds: 2), () {

                                setState(() {
                                  tappedCharge = false ;
                                });

                              }); //Timer to wait
                              
                            });
                                  
                          },
                                  
                        );
                        
                      }).toList(),

                      style: TextStyle(
                        color: Colors.white ,
                        shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
                      ),
                                  
                      hint: Text(
                                  
                        "Liste de demandes",
                                  
                        textAlign: TextAlign.center,
                                  
                        style: TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
                        ),
                                  
                      ),
                                  
                      icon:  const Icon(
                        Icons.arrow_downward,
                        color: Colors.black
                      ),
                                  
                      underline: Container(),
                      
                    ),
                  ),
               
                ],
              ),
            ),

            const SizedBox(height: 20) ,

            affichageListe(isAttentePage , isRdvPage),

          ],
        ),

      ),

      bottomNavigationBar: ToolBar.bottomNavBar(2, widget.color , context),//Voir classe ToolBar
    );
  }
}