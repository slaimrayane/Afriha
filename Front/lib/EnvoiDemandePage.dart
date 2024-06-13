// ignore_for_file: must_be_immutable, file_names, avoid_print

import 'dart:async';
import 'dart:math' ;
import 'package:http/http.dart' as http ;
import 'dart:convert';

import 'package:afriha_app/locationPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Classes.dart';

import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class EnvoiPage extends StatefulWidget {
  
  //final Client client;
  final int color ; //pour Dark/White changement
  final Domaine domaine ; //le domaine cliquée
  final Prestation prestation ;

  const EnvoiPage({super.key , required this.color , required this.domaine , required this.prestation });

  @override
  State<EnvoiPage> createState() => _EnvoiPageState();
}

class _EnvoiPageState extends State<EnvoiPage> {

  String description = "";
  DateTime? dateDebut ;
  DateTime? dateFin ;
  String? addresse ;
  double lat = 5.5 ;
  double long = 10.5 ;

  bool switchValue = false ;
  bool emptyEntries = false ;
  bool tappedCharge = false ;

  Future<void> createDemande(int clientId,int domaineId, int prestationId) async {

    Random random = Random() ;
    int randomSeconds = random.nextInt(3) + 4;

    setState(() { //Loading mode
      tappedCharge = true ;
    });


    UserData cliData = Provider.of<UserData>(context , listen: false);    

    final String url = 'http://127.0.0.1:8000/existences/api/clients/$clientId/domaines/$domaineId/Prestations/$prestationId/demande/';
    

    try {

      final response = await http.post(
        Uri.parse(url),

        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },

        body: jsonEncode({

          "type": switchValue ? "urgent" : "simple",
          "date": "${dateDebut!.year}-${dateDebut!.month}-${dateDebut!.day}" ,
          "Tarif": widget.prestation.tarifEstime ,
          "latitude": lat ,
          "longitude": long ,
          "localisation": addresse ,
          "heure_debut": "${dateDebut!.hour}:${dateDebut!.minute}:${dateDebut!.second}",
          "heure_fin": "${dateFin!.hour}:${dateFin!.minute}:${dateFin!.second}",
          "description": description.isEmpty ? "aucune description" : description ,

        }),
      );
      
      if (response.statusCode == 201){
        
        print('Demande created successfully');

        Map jsonData = jsonDecode(response.body) ;
        
        Demande demande = Demande( //Création nouvelle demande
          id: jsonData['id'], 
          client: UserData.client , 
          isUrgent: switchValue , 
          prestation: widget.prestation ,
          description: description, 
          dateDebut: dateDebut! , 
          dateFin: dateFin! , 
          dateRealisation: DateTime.now() , 
          addresse: addresse! , 
          tarifEstime: jsonData['Tarif'],
          isConfirmed: false,
        );

        cliData.addDemande(demande) ;

        Timer( Duration(seconds: randomSeconds), () {

          Navigator.popUntil(context, ModalRoute.withName('')) ;
          Navigator.pushNamed(context, "/homeCli") ;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:  Text('Votre Demande a été crée , veuillez vérifier votre liste de demande'),
              duration:  Duration(seconds: 3),
            ),
          );

        });


      } else {
        print('Failed to create Demande: ${response.statusCode}');
        

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
      print('Error creating Demande: $error');
    }
  }

  void affectAddresse(String adr){

    setState(() {
      addresse = adr ;
    });
    
  }

  void affectLatLong(double lat , double long){
    setState(() {
      this.lat = lat ;
      this.long = long ;
    });
  }

  void dateTimePicker(bool isDebut) async { //Notre calendrier et setter de variable type DateTime

    DateTime? output ;

    output = await showOmniDateTimePicker(

      context: context,

      initialDate: dateDebut ?? (dateFin ?? DateTime.now()), //initialisation

      firstDate: dateDebut ?? (dateFin?.subtract(const Duration(hours: 5)) ?? DateTime.now()) , //première date qui s'affiche

      lastDate: dateDebut?.add(const Duration(hours: 5)) ?? (dateFin ?? DateTime.now().add( const Duration(days: 3652))) , //dernière date

      is24HourMode: true,
      isShowSeconds: false,
      minutesInterval: 10,
      secondsInterval: 1,

      isForce2Digits: true,

      borderRadius: const BorderRadius.all(Radius.circular(16)),

      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),

      //quelques ptites touches sur décoration et mouvements  

      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },

      transitionDuration: const Duration(milliseconds: 200),

      barrierDismissible: true,

      selectableDayPredicate: (dateTime) {
        // Disable 25th Feb 2023
        if (dateTime == DateTime(2023, 2, 25)) {
          return false;
        } else {
          return true;
        }
      },
    );

    (isDebut) ? dateDebut = output : dateFin = output ;

    setState(() {
      controlEmptiness() ;
    });

  }

  void controlEmptiness(){

    if((dateDebut == null || dateFin == null || addresse == null) && !emptyEntries){
      setState(() {
        emptyEntries = true ;
        print(emptyEntries) ;
      });
    }

    if(dateDebut != null && dateFin != null && addresse != null && emptyEntries){
      setState(() {
        emptyEntries = false ;
        print(emptyEntries) ;
      });
    }
  }
  
  int filterDemandeEnCoursLength(){ //trouver nombre de demandes déja créé en cours pour controller le spam

    int cpt = 0 ;

    for (var demande in UserData.demandes) {
      if(!demande.isFinished()){
        cpt++ ;
      }
    }

    return cpt;

  }

  Widget dateDebutAffichage(){

    String data = (dateDebut == null) ? "Date début avec temps" : "$dateDebut" ;

    return Text(
      data ,
      overflow: TextOverflow.fade,
      style: TextStyle(
        fontFamily: "Nunito" ,
        fontWeight: (dateDebut == null) ? FontWeight.w100 : FontWeight.w700 ,
        color: Color(ToolBar.coulTextStatic(widget.color)) ,
      ),
    ) ;
  }

  Widget dateFinAffichage(){

    String data = (dateFin == null) ? "Votre date de fin de disponibilitée.." : "$dateFin" ;

    return Text(
      data ,

      overflow: TextOverflow.fade,
      style: TextStyle(
        fontFamily: "Nunito" ,
        fontWeight: (dateFin == null) ? FontWeight.w100 : FontWeight.w700 ,
        color: Color(ToolBar.coulTextStatic(widget.color)) ,
      ),
    ) ;
  }

  Widget addresseAffichage(){

    String addresse = (this.addresse == null) ? "Addresse..." : "${this.addresse}" ;

    return Text(
      addresse ,

      overflow: TextOverflow.fade,
      style: TextStyle(
        fontFamily: "Nunito" ,
        fontWeight: (this.addresse == null) ? FontWeight.w100 : FontWeight.w700 ,
        color: Color(ToolBar.coulTextStatic(widget.color)) ,
      ),
    ) ;
  }

  Widget rowElement(bool isDomaine){ //retourne une ligne d'affichage soit domaine wella prestation

    String description = (isDomaine) ? "Domaine : ${widget.domaine.name}" : "Prestation : ${widget.prestation.nom}" ;

    return Row( //Image + Domaine/Prestation

      children:[

    
        Image.asset("Images/tag.png"),
        

        const SizedBox(width: 5.0),
        
        Expanded(

          child: Text( //titre
            description ,
          
            maxLines: 1,   
            overflow: TextOverflow.ellipsis,
          
            style: TextStyle(
              fontFamily: "Nunito",
              fontWeight: FontWeight.w700,
              fontSize: 16.0 , 
              color : Colors.white ,
              shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),

            ),
                        
          ),
        ),

      ],

    ); 
  }

  Widget bodyPageNotCharged(){

    return ListView(

      children: [

        Column( //Main

          children: [
            
            Container( //informations de tous
            
              
              padding:const EdgeInsets.symmetric(vertical : 20.0 , horizontal: 20.0),
              margin:const EdgeInsets.fromLTRB(40, 30, 40, 30),
              
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
            
              child: Container(

                padding:const EdgeInsets.symmetric(vertical : 10.0 , horizontal: 10.0),
                width: double.infinity,

                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(20.0),
                  color: Color(widget.color) ,

                ),

                child :Column(

                  crossAxisAlignment: CrossAxisAlignment.center,

                  children:[
                    
                    Row( //Image + Domaine/Prestation
                      
                      children: [

                        SizedBox( //Image
                          height: 100.0,
                          child: Image.asset(widget.domaine.imgPath),
                        ),

                        const SizedBox(width : 10.0),

                        Expanded(

                          child: Column( //Domaine fou9ou prestation
                          
                            crossAxisAlignment: CrossAxisAlignment.start,
                          
                            children: [
                              rowElement(true), //afficher le domaine 
                              const SizedBox(height: 10.0),
                              rowElement(false), //afficher la prestation
                            ],
                          
                          ),
                        )

                      ],

                    ),

                    const Divider( //un fil qui s'affiche comme décoration
                      height: 40.0,
                      thickness: 5,
                      color: Colors.white,
                    ),

                    Container(
                    
                      padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 5 , vertical: 5),
                                      
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.white,
                      ),
                    
                      child: Text(
                        "Détails : ",
                      
                        style: TextStyle(
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0, 
                          color : Colors.black ,
                          shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10.0),

                    Text(
                      "Tarif estimé : ${widget.prestation.tarifEstime}Da",
                    
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0, 
                        color : Colors.white ,
                        shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
                      ),
                    ),

                    const SizedBox(height: 5.0),

                    Text(
                      "Durée estimée : ${widget.prestation.dureeEstime.substring(0 , 6).replaceFirst(":", " heures et ").replaceFirst(":", " minutes .")}",

                        textAlign: TextAlign.center,

                        style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0, 
                        color : Colors.white ,
                        shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
                      ),
                    ),

                  ],
                ),
              
              ),

            ),


            Container( //Else , all inputs are here
            
              padding:const EdgeInsets.symmetric(vertical : 20.0 , horizontal: 20.0),
              margin:const EdgeInsets.fromLTRB(40, 30, 40, 30),
              
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

              child: Column( //Main Inputs

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Center(

                    child: Text(
                      "Veuillez remplir quelques informations avant l'envoi : ",

                      textAlign: TextAlign.center,
                    
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0, 
                        color : Color(ToolBar.coulTextStatic(widget.color)) ,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40.0),

                  TextField( //Descripion

                    minLines: 2,
                    maxLines: 5,
                  
                    decoration: InputDecoration(
                  
                      hintText: 'Description ...',
                            
                      hintStyle:const TextStyle(
                        fontFamily: "Nunito" ,
                        fontWeight: FontWeight.w100,
                      ),
                            
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(
                          color: Color(widget.color),
                          width: 2.0 ) ,
                      ),
                    ),
                  
                    style: TextStyle(
                      fontFamily: "Nunito" ,
                      fontWeight: FontWeight.w600,
                      color: Color(ToolBar.coulTextStatic(widget.color)) ,
                    ),
                  
                    onChanged: (value) {
                      // Perform search logic here
                      description = value ;
                    },
                  
                  ),

                  const SizedBox(height: 20.0),

                  Text(
                    "Je serai disponible de :" ,

                    style: TextStyle(
                      fontFamily: "Nunito" ,
                      fontWeight: FontWeight.w600,
                      color: Color(ToolBar.coulTextStatic(widget.color)) ,
                    ),
                  ),

                  const SizedBox(height: 5.0),

                  Row( //Heure Début

                    children: [

                      Expanded(
                        child: Container( //la boite noire

                          padding:const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 10.0),
                          margin:const EdgeInsets.all(0.0),
                          
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Color(ToolBar.coulTextStatic(widget.color)), width: 2.0) ,
                            color: Color(ToolBar.coulButtonStatic(widget.color)),
                            
                          ),

                          child: Row( //elements
                            children: [

                              Expanded(child: dateDebutAffichage()),

                              IconButton(
                                icon:const Icon(Icons.calendar_month),
                                                              
                                highlightColor:const Color.fromARGB(124, 255, 191, 0),
                                color: Color(ToolBar.coulButtonStatic(widget.color)),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(Color(widget.color))
                                ),
                                
                                onPressed: () async {

                                  setState(() {
                                    dateTimePicker(true) ;
                                  });
                                                              
                                },
                              ),

                            ],
                          ) ,

                        ),

                      ),

                    ],
                  ),
                
                  const SizedBox(height: 10.0),
                  
                  Text(
                    "Jusqu'à : " ,

                    style: TextStyle(
                      fontFamily: "Nunito" ,
                      fontWeight: FontWeight.w600,
                      color: Color(ToolBar.coulTextStatic(widget.color)) ,
                    ),
                  ),

                  const SizedBox(height: 5.0),

                  Row( //Heure Fin

                    children: [

                      Expanded(
                        child: Container( //la boite noire

                          padding:const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 10.0),
                          margin:const EdgeInsets.all(0.0),
                          
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Color(ToolBar.coulTextStatic(widget.color)), width: 2.0) ,
                            color: Color(ToolBar.coulButtonStatic(widget.color)),
                            
                          ),

                          child: Row( //elements
                            children: [

                              Expanded(child: dateFinAffichage()),

                              IconButton(
                                icon:const Icon(Icons.calendar_month),
                                                              
                                highlightColor:const Color.fromARGB(124, 255, 191, 0),
                                color: Color(ToolBar.coulButtonStatic(widget.color)),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(Color(widget.color))
                                ),
                                
                                onPressed: () {

                                  setState(() {
                                    dateTimePicker(false) ;
                                    controlEmptiness() ;
                                  });
                                  
                                },
                              ),

                            ],
                          ) ,

                        ),

                      ),

                    ],
                  ),

                  const SizedBox(height: 20.0),

                  Text(
                    "Votre addresse :" ,

                    style: TextStyle(
                      fontFamily: "Nunito" ,
                      fontWeight: FontWeight.w600,
                      color: Color(ToolBar.coulTextStatic(widget.color)) ,
                    ),
                  ),

                  const SizedBox(height: 5.0),
                  
                  Row( //Addresse

                    children: [

                      Expanded(
                        child: Container( //la boite noire

                          padding:const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 10.0),
                          margin:const EdgeInsets.all(0.0),
                          
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Color(ToolBar.coulTextStatic(widget.color)), width: 2.0) ,
                            color: Color(ToolBar.coulButtonStatic(widget.color)),
                            
                          ),

                          child: Row(
                            children: [

                              Expanded(
                                child: addresseAffichage() ,
                              ),

                              IconButton(
                                icon:const Icon(Icons.location_on),
                                                              
                                color: Color(ToolBar.coulButtonStatic(widget.color)),
                                highlightColor:const Color.fromARGB(124, 255, 191, 0),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(Color(widget.color)),
                                                              
                                ),
                                                              
                                onPressed: () {
                                  addresse = "picked addresse" ;
                                  controlEmptiness();
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LocationPage(affectAddresse: affectAddresse , affectLatLong: affectLatLong,))) ;
                                },
                              ),

                            ],
                          ) ,

                        ),

                      ),

                    ],
                  ),

                  const SizedBox(height: 20.0),

                  const Center(
                    child: Text(
                      "trouverez vous cet rendez-vous comme urgent :" ,

                      textAlign: TextAlign.center,
                    
                      style: TextStyle(
                        fontFamily: "Nunito" ,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 5) ,

                  Row( //SWITCH

                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [

                      Container( //NO

                        padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 5),
                  
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: !switchValue ? Color(widget.color) : Colors.transparent ,
                        ),

                        child: Text(
                          "non" ,
                        
                          style: TextStyle(
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w700, 
                            color : !switchValue ? Colors.white : Colors.black ,
                            shadows: !switchValue ? List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)) : null,
                          ),
                        ),
                      ),

                      const SizedBox(width: 5),

                      Switch(
                        value: switchValue,

                        activeColor: Color(widget.color) ,

                        onChanged: (value) {

                          setState(() {
                            switchValue = value;
                          });
                                                   
                        },
                      ),
                    
                      const SizedBox(width: 5),

                      Container(//YES

                        padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 5),
                  
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: switchValue ? Color(widget.color) : Colors.transparent ,
                        ),


                        child: Text(
                          "oui" ,
                        
                          style: TextStyle(
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w700, 
                            color : switchValue ? Colors.white : Colors.black ,
                            shadows: switchValue ? List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)) : null,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40.0),

                ],
              ),
            ),

            const SizedBox(height: 10.0),

            ElevatedButton( //Envoyer Bouton

              onPressed: () {

                int length = filterDemandeEnCoursLength() ;

                if(emptyEntries){ //s'il existe au moins une entrée vide

                  String message = "" ;

                  if(dateDebut == null) message = "date de début de disponibilité";
                  if(dateFin == null) message = "date de fin de disponibilité" ;
                  if(addresse == null) message = "addresse de rendez-vous";

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:  Text('Remplissez $message avant de valider'),
                      duration: const  Duration(seconds: 3),
                    ),
                  ) ;
                  
                } else if(dateDebut!.compareTo(dateFin!) >= 0){ //si la saisie n'est pas logique

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:  Text('Les dates saisies ne peuvent pas ètre crédibles'),
                      duration:  Duration(seconds: 3),
                    ),
                  ) ;

                }else if(length >= 3){

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:  Text('Vous avez arrivé au nombre maximum d envoi de demandes , veuillez enlever une demande pour créer une.'),
                      duration:  Duration(seconds: 5),
                    ),
                  ) ;


                } else { //sinon , on créer la demande
                  createDemande(UserData.client.id , widget.domaine.id, widget.prestation.id) ;
                }

              },

              style: ElevatedButton.styleFrom(
                backgroundColor: emptyEntries ? Colors.blueGrey[50]  : Colors.green[500],
                padding:const EdgeInsets.symmetric(horizontal: 30.0 , vertical: 20.0),

                side:const BorderSide(
                  style: BorderStyle.solid  ,
                  color: Colors.transparent ,
                  width: 4 ,
                ),
              ),

              child: Text(
                "Envoyer",
              
                style: TextStyle(
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w700,
                  fontSize: 25.0, 
                  color : emptyEntries ? Colors.black : Colors.white,
                  shadows: emptyEntries ? null : List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
                ),

              ),
            ),

            const SizedBox(height: 20.0),
          ],

        ),
      ],
    );

        
  }

  @override
  void initState(){

    super.initState() ;
    controlEmptiness() ;
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(

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
                      "Détails de demande" ,
                        
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
    
      body: !tappedCharge ? bodyPageNotCharged() : ToolBar.shortLoadingScreen(widget.color ,0xFFFFFFFF) ,

      bottomNavigationBar: ToolBar.bottomNavBar(1, widget.color , context),
      
    );
  }
}