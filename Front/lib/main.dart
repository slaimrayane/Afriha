// ignore_for_file: avoid_print

import 'package:afriha_app/BoiteDialgue.dart';
import 'package:afriha_app/EnvoiDemandePage.dart';
import 'package:afriha_app/FirstPage.dart';
import 'package:afriha_app/Inscription_artisan.dart';
import 'package:afriha_app/Inscription_client.dart';
import 'package:afriha_app/ListeDemande.dart';
import 'package:afriha_app/RechPrestation.dart';
import 'package:afriha_app/acceuilArt.dart';
import 'package:afriha_app/accueilClien.dart';
import 'package:afriha_app/choixInscription.dart';
import 'package:afriha_app/connexion.dart';
import 'package:afriha_app/Profil.dart';
import 'package:afriha_app/splash.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'Classes.dart';

const String url = 'http://127.0.0.1:8000/existences/api/domaines/';
const String url2= 'http://127.0.0.1:8000/existences/api/prestations/domaine/';

const int color = 0xFF54A2FF ;

Map<String, WidgetBuilder> routes = {} ;

Future<List<Prestation>> _fetchPrestationsForDomaine(Domaine domaine) async {

  List<Prestation> prestations = [] ;
  
  try {

    final response = await http.get(Uri.parse('$url2?domaine_id=${domaine.id}'));

    if (response.statusCode == 200) {

      String utfResponse = utf8.decode(response.bodyBytes) ;

      final List<dynamic> jsonData = jsonDecode(utfResponse);

      prestations = jsonData.map((item) {

        return Prestation(
          domaine: domaine,
          id: item['id'],
          nom: item['nom_prestation'], 
          tarifEstime: item['prix_approximatif'], 
        dureeEstime: item['duree_de_realisation']);

      }).toList() ;

    } else {
      print('Failed to fetch prestations: ${response.statusCode}');
    }

  } catch (error) {
    print('Error fetching prestations: $error');
  }

  return prestations ;

}

Future<List<Demande>> fetchDemandesForClient(Client client) async {

  List<Demande> demandes = [] ;

  final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/existences/api/clients/${client.id}/demandes/'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
  );
  
  if (response.statusCode == 200) {

    // If the server returns a 200 OK response, parse the JSON

    print(utf8.decode(response.bodyBytes));

    String utfResponse = utf8.decode(response.bodyBytes) ;

    List<dynamic> jsonData = jsonDecode(utfResponse);

    demandes = jsonData.map((item){

      Prestation prestation = Prestation(id: -1, nom: "nullPrest", tarifEstime: -100, dureeEstime: "10:00:30", domaine: Domaine(imgPath: "kkk", name: "NullDom", prestations: [], id: -1));

      List<String> listeYearMonthDay = item["date"].toString().split("-");
      List<String> listDebHouMinSec = item["heure_debut"].toString().split(":");
      List<String> listFinHouMinSec = item["heure_fin"].toString().split(":");
      List<String> listYMDCreated = item["created_at"].toString().substring(0 , 10).split("-");
      List<String> listHMSCreated = item["created_at"].toString().substring(11 , 19).split(":") ;

      List<int> intlisteYearMonthDay = listeYearMonthDay.map((eleTemp) => int.parse(eleTemp)).toList() ;
      List<int> intlistDebHouMinSec = listDebHouMinSec.map((eleTemp) => int.parse(eleTemp)).toList() ;
      List<int> intlistFinHouMinSec = listFinHouMinSec.map((eleTemp) => int.parse(eleTemp)).toList() ;

      List<int> intlistYMDCreated = listYMDCreated.map((eleTemp) => int.parse(eleTemp)).toList();
      List<int> intListHMSCreated = listHMSCreated.map((eleTemp) => int.parse(eleTemp)).toList();

      Demande demande = Demande(
        
        id: item["id"], 
        client: client, 
        isUrgent: (item['type'] == "urgent") ? true : false,
        prestation: prestation, 
        description: item['description'],
        dateDebut: DateTime(intlisteYearMonthDay[0] , intlisteYearMonthDay[1] , intlisteYearMonthDay[2] , intlistDebHouMinSec[0] , intlistDebHouMinSec[1] , intlistDebHouMinSec[2]), 
        dateFin: DateTime(intlisteYearMonthDay[0] , intlisteYearMonthDay[1] , intlisteYearMonthDay[2] , intlistFinHouMinSec[0] , intlistFinHouMinSec[1] , intlistFinHouMinSec[2]),
        dateRealisation: DateTime(intlistYMDCreated[0] , intlistYMDCreated[1] , intlistYMDCreated[2] , intListHMSCreated[0] , intListHMSCreated[1] , intListHMSCreated[2]),
        addresse: item["localisation"],
        tarifEstime: item["Tarif"] ,
        isConfirmed: item['Confirme'],
      
      );

      if(item['notee']) demande.commentaire = Commentaire(avisClient: "Done", notationClient: 0) ; //commentaire ici est verbalement rempli par garbage data puisque on aura pas besoin au coté client dans l'application , on le remplie pour enlever le null dans commentaire

      return demande ;

    }).toList();


    for(int i = 0 ; i < demandes.length ; i++){
      demandes[i].prestation = await fetchPrestation(jsonData[i]["prestation"]);
      demandes[i].artisants = await fetchArtisantsForDemande(demandes[i]) ; //récuperer liste des artisants qui ont accepté la demande
      if(demandes[i].isConfirmed) demandes[i].artisant = await fetchArtisant(jsonData[i]['artisan']) ;
    }

    return demandes;

  } else {
    // If the server did not return a 200 OK response, throw an exception
    throw Exception('Failed to load Demande list');
  }
}

Future<List<Demande>> fetchDemandesForArtisant(Artisant artisant) async { //get les demandes que l'artisant peut les récupérer

  List<Demande> demandes = List.empty(growable: true) ;

  String url = "http://127.0.0.1:8000/existences/api/artisans/${artisant.id}/demandes/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {

    String utfResponse = utf8.decode(response.bodyBytes) ;

    List<dynamic> jsonData = jsonDecode(utfResponse);

    demandes = jsonData.map((item){

      Prestation prestation = Prestation(id: -1, nom: "nullPrest", tarifEstime: -100, dureeEstime: "10:00:30", domaine: Domaine(imgPath: "kkk", name: "NullDom", prestations: [], id: -1));
      Client client = Client(id: -1, idUser: -1 , numTel: 000 , nomUtilisateur: "nullUser", compte: "NullCompte@com", imagePath: "Images/20471174.jpg") ; //junk Info

      List<String> listeYearMonthDay = item["date"].toString().split("-");
      List<String> listDebHouMinSec = item["heure_debut"].toString().split(":");
      List<String> listFinHouMinSec = item["heure_fin"].toString().split(":");
      List<String> listYMDCreated = item["created_at"].toString().substring(0 , 10).split("-");
      List<String> listHMSCreated = item["created_at"].toString().substring(11 , 19).split(":") ;

      List<int> intlisteYearMonthDay = listeYearMonthDay.map((eleTemp) => int.parse(eleTemp)).toList() ;
      List<int> intlistDebHouMinSec = listDebHouMinSec.map((eleTemp) => int.parse(eleTemp)).toList() ;
      List<int> intlistFinHouMinSec = listFinHouMinSec.map((eleTemp) => int.parse(eleTemp)).toList() ;

      List<int> intlistYMDCreated = listYMDCreated.map((eleTemp) => int.parse(eleTemp)).toList();
      List<int> intListHMSCreated = listHMSCreated.map((eleTemp) => int.parse(eleTemp)).toList();

      Demande demande = Demande(
        
        id: item["id"], 
        client: client, 
        isUrgent: (item['type'] == "urgent") ? true : false,
        prestation: prestation, 
        description: item['description'],
        dateDebut: DateTime(intlisteYearMonthDay[0] , intlisteYearMonthDay[1] , intlisteYearMonthDay[2] , intlistDebHouMinSec[0] , intlistDebHouMinSec[1] , intlistDebHouMinSec[2]), 
        dateFin: DateTime(intlisteYearMonthDay[0] , intlisteYearMonthDay[1] , intlisteYearMonthDay[2] , intlistFinHouMinSec[0] , intlistFinHouMinSec[1] , intlistFinHouMinSec[2]),
        dateRealisation: DateTime(intlistYMDCreated[0] , intlistYMDCreated[1] , intlistYMDCreated[2] , intListHMSCreated[0] , intListHMSCreated[1] , intListHMSCreated[2]),
        addresse: item["localisation"],
        tarifEstime: item["Tarif"] ,
        isConfirmed: item['Confirme'], // = false car dans la bdd c'est déja filtré
      
      );

      return demande ;

    }).toList();

    for(int i = 0 ; i < demandes.length ; i++){

      if(demandes[i].isConfirmed){

        demandes[i].artisant = await fetchArtisant(jsonData[i]['artisan']) ;
        
        if(demandes[i].artisant!.id != artisant.id){

          demandes.remove(demandes[i]);
          jsonData.remove(jsonData[i]);
          i-- ; //puisque on a supprimé un élément
          continue ; //si la demande comporte un rendez vous qui n'est pas cel de cet artisant , il ne va pas la voire
        } 
        
      }

      if(demandes[i].isUrgent && !artisant.status && !demandes[i].isFinished() && !demandes[i].isConfirmed){ //Si la statut de l'artisan n'est pas disponible pour les demandes urgentes

        demandes.remove(demandes[i]) ;
        jsonData.remove(jsonData[i]);
        i-- ;
        continue ;
      }

      //récuperer les dernières informations
      demandes[i].prestation = await fetchPrestation(jsonData[i]["prestation"]);
      demandes[i].client = await fetchClient(jsonData[i]["client"]) ;
      demandes[i].artisants = await fetchArtisantsForDemande(demandes[i]) ; //récuperer liste des artisants qui ont accepté la demande
    }

    return demandes;

  } else {
    // If the server did not return a 200 OK response, throw an exception
    throw Exception('Failed to load Demande list');
  }

}

Future<List<Artisant>> fetchArtisantsForDemande(Demande demande) async{ //récupérer les artisants qui ont accepté la demande 

  List<Artisant> artisants = List.empty(growable: true) ;

  String url = "http://127.0.0.1:8000/existences/api/clients/${demande.client.id}/demandes/${demande.id}";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {

    String utfResponse = utf8.decode(response.bodyBytes) ;

    List<dynamic> jsonData = jsonDecode(utfResponse);

    artisants = jsonData.map((item){

      return Artisant(
        nomUtilisateur: item['user']['username'], 
        compte: item['user']['email'], 
        numTel: item['num_phone'],
        id: item['id'], 
        idUser: item['user']['id'],
        status: item['status'],
        imagePath: "Images/20471174.jpg", 
      notation: Notation(notation: item['notation'], nbrNota: item['nb_interventions']));

    }).toList();

    for(int i = 0 ; i < artisants.length ; i++){
      artisants[i].interventions = await fetchCommentaireForArtisan(artisants[i]);
    }

    return artisants;

  } else {
    // If the server did not return a 200 OK response, throw an exception
    throw Exception('Failed to load Demande list');
  }
}

Future<List<Commentaire>> fetchCommentaireForArtisan(Artisant artisant) async{

  List<Commentaire> commentaires = List.empty(growable: true) ;

  String url = 'http://127.0.0.1:8000/existences/api/artisans/${artisant.id}/commentaires/' ;

  final response = await http.get(Uri.parse(url));

  if(response.statusCode == 200){

    String utfResponse = utf8.decode(response.bodyBytes) ;

    List<dynamic> jsonData = jsonDecode(utfResponse);

    commentaires = jsonData.map((item) {

      return Commentaire(
        avisClient: item['commentaire'], 
        notationClient: item['notation'],
      );

    }).toList();

    for(int i = 0 ; i < commentaires.length ; i++){
      commentaires[i].demande = await fetchDemande(jsonData[i]['demande']) ;
    }

    return commentaires ;

  }else {
    // If the server did not return a 200 OK response, throw an exception
    throw Exception('Failed to load Interventions');
  }


}

Future<List<Message>> fetchMessagesForDialogue(BoiteDialogue dialogue) async{

  List<Message> messages = List.empty(growable: true) ;

  int idSender = UserData.isClient ? dialogue.client.idUser : dialogue.artisant.idUser ;
  int idReceiver = !UserData.isClient ? dialogue.client.idUser : dialogue.artisant.idUser ;

  String url = 'http://127.0.0.1:8000/existences/api/get_messages/$idSender/$idReceiver/' ;

  final response = await http.get(Uri.parse(url));

  if(response.statusCode == 200){

    String utfResponse = utf8.decode(response.bodyBytes) ;

    List<dynamic> jsonData = jsonDecode(utfResponse);

    messages = jsonData.map((item) {

      return Message(
        contenu: item['Message'],
        isSender: item['is_sender'] ,
      );

    }).toList();

    return messages ;

  }else {
    // If the server did not return a 200 OK response, throw an exception
    throw Exception('Failed to load Messages');
  }

}

Future<List<Notiification>> fetchNotiForUser() async{

  int idUser = UserData.isClient ? UserData.client.idUser : UserData.artisan.idUser ;

  String url = "http://127.0.0.1:8000/existences/api/users/$idUser/notifications/" ;

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {

    String utfResponse = utf8.decode(response.bodyBytes) ;

    List<dynamic> jsonData = jsonDecode(utfResponse);

    // Map JSON data to noti objects
    final List<Notiification> notifications= ( jsonData.map((item) {   

      List<String> listYMDCreated = item["date_envoie"].toString().substring(0 , 10).split("-");
      List<String> listHMSCreated = item["date_envoie"].toString().substring(11 , 19).split(":") ; 

      List<int> intlistYMDCreated = listYMDCreated.map((eleTemp) => int.parse(eleTemp)).toList();
      List<int> intListHMSCreated = listHMSCreated.map((eleTemp) => int.parse(eleTemp)).toList();

      Notiification notification = Notiification(
        date:  DateTime(intlistYMDCreated[0] , intlistYMDCreated[1] , intlistYMDCreated[2] , intListHMSCreated[0] , intListHMSCreated[1] , intListHMSCreated[2]), 
        notification: item['notification'], 
      vue: item['vue']);

      return notification ;

    }).toList()) ;

    return notifications.reversed.toList() ;

  } else {
    throw Exception('Failed to load cookies , I mean notis ... : ${response.statusCode}');
  }

}

Future<void> patchVueNotis() async{

  int idUser = UserData.isClient ? UserData.client.idUser : UserData.artisan.idUser ;

  String url = "http://127.0.0.1:8000/existences/api/users/$idUser/notifications/vue/" ;

  final response = await http.patch( //modifier la bdd notification pour notifier qu'elle est vue
    Uri.parse(url),

    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },

    body: jsonEncode({

    }),

  );

  if(response.statusCode == 200){

    print("Vue...") ;

  } else {
    throw Exception('Failed to patch cookies: ${response.statusCode}');
  }

}

Future<void> sendNotification(int idUser , String contenu) async{ //envoyer une notification lel kesh user

  String url = "http://127.0.0.1:8000/existences/api/users/$idUser/notifications/send/" ;

  final response = await http.post( //modifier la bdd notification pour notifier qu'elle est vue
    Uri.parse(url),

    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },

    body: jsonEncode({
      "notification" : contenu,
    }),

  );

  if(response.statusCode == 201){

    print("Notification created successfully") ;

  }else {
    throw Exception('Failed to post notis: ${response.statusCode}');
  }

}

Future<List<Domaine>> fetchlistDomaines() async { //fetching Domaines

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {

    String utfResponse = utf8.decode(response.bodyBytes) ;

    List<dynamic> jsonData = jsonDecode(utfResponse);

    // Map JSON data to Domaine objects
    final List<Domaine> domaines = ( jsonData.map((item) {    

      Domaine domaine = Domaine(
        name: item['nom_domaine'] ?? '',
        imgPath: item['photo'] ?? '',
        prestations: [] , // Update this based on your Domaine class structure
        id:  item['id'],
      );

      return domaine ;

    }).toList()) ;

    Domaine domaine ;

    for (int i = 0; i < domaines.length ; i++) { //fetch prestations
      domaine = domaines[i] ;
      domaine.prestations = await _fetchPrestationsForDomaine(domaine) ;
    }

    return domaines;

  } else {
    throw Exception('Failed to load data: ${response.statusCode}');
  }
}

Future<Domaine> fetchDomaine(int domaineId) async {

  String url = "http://127.0.0.1:8000/existences/api/domaines/$domaineId" ;

  try {

    final response = await http.get(Uri.parse(url)) ;

    if(response.statusCode == 200){

      String utfResponse = utf8.decode(response.bodyBytes) ;

      Map jsonData = jsonDecode(utfResponse);

      Domaine domaine = Domaine(
        imgPath: jsonData["photo"], 
        name: jsonData["nom_domaine"], 
        prestations: [], 
      id: jsonData['id']);

      domaine.prestations = await _fetchPrestationsForDomaine(domaine) ;

      return domaine ;
      
    }else{

      print('Failed to fetch prestations: ${response.statusCode}');

    }
    
  } catch (e) {
    print('Error fetching prestations: $e');
  }

  return Domaine(imgPath: "/Images/Null.png", name: "NullDomaine", prestations: [], id: -1) ;

} 

Future<Prestation> fetchPrestation(int prestationId) async {

  String url = "http://127.0.0.1:8000/existences/api/prestations/$prestationId" ;

  try {

    final response = await http.get(Uri.parse(url)) ;

    if(response.statusCode == 200){

      String utfResponse = utf8.decode(response.bodyBytes) ;

      Map jsonData = jsonDecode(utfResponse);

      Domaine domaine = await fetchDomaine(jsonData['domaine_id']);

      Prestation prestation = Prestation(id: jsonData['id'], nom: jsonData["nom_prestation"], tarifEstime: jsonData["prix_approximatif"], dureeEstime: jsonData["duree_de_realisation"], domaine: domaine);

      return prestation ;

    }else{

      print('Failed to fetch prestations: ${response.statusCode}');

    }
    
  } catch (e) {
    print('Error fetching prestations: $e');
  }

  return Prestation(id: -1, nom: 'NullPrest', tarifEstime: -100, dureeEstime: "12:20:20", domaine: Domaine(imgPath: "/Images/Null.png", name: "NullDomaine", prestations: [], id: -1));

} 

Future<Client> fetchClient(int clientId) async {

  String url = "http://127.0.0.1:8000/existences/api/clients/$clientId" ;

  try {

    final response = await http.get(Uri.parse(url)) ;

    if(response.statusCode == 200){

      String utfResponse = utf8.decode(response.bodyBytes) ;

      Map jsonData = jsonDecode(utfResponse);

      Client client = Client(
        id: jsonData['id'], 
        idUser: jsonData['user']['id'],
        numTel: jsonData['num_phone'],
        nomUtilisateur: jsonData['user']['username'], 
        compte: jsonData["user"]['email'], 
        imagePath: "Images/20471174.jpg",
      );

      return client ;
      
    } else {

      print('Failed to fetch prestations: ${response.statusCode}');

    }
    
  } catch (e) {
    print('Error fetching prestations: $e');
  }

  return Client(id: -1, idUser: -1 , numTel: 000 ,nomUtilisateur: "nullUser", compte: "NullCompte@com", imagePath: "Images/20471174.jpg");

}

Future<Artisant> fetchArtisant(int artisantId) async {

  String url = "http://127.0.0.1:8000/existences/api/artisans/$artisantId" ;

  try {

    final response = await http.get(Uri.parse(url)) ;

    if(response.statusCode == 200){

      String utfResponse = utf8.decode(response.bodyBytes) ;

      Map jsonData = jsonDecode(utfResponse);

      Artisant artisant = Artisant(
        nomUtilisateur: jsonData['user']['username'], 
        compte: jsonData['user']['email'], 
        numTel: jsonData['num_phone'],
        id: jsonData['id'], 
        idUser: jsonData['user']['id'],
        status: jsonData['status'],
        imagePath: "Images/20471174.jpg", 

      notation: Notation(notation: jsonData['notation'], nbrNota: jsonData['nb_interventions']));

      artisant.interventions = await fetchCommentaireForArtisan(artisant) ;

      return artisant ;
      
    } else {

      print('Failed to fetch Artisant: ${response.statusCode}');

    }
    
  } catch (e) {
    print('Error fetching prestations: $e');
  }

  return Artisant(id: -1, idUser: -1 ,numTel: 000, nomUtilisateur: "nullUser",compte: "NullCompte@com",  notation: Notation(notation: 0, nbrNota: 0), imagePath: "Images/20471174.jpg" , status: false);

}

Future<Demande> fetchDemande(int demandeId) async { //récuperer demande selon id

  String url = "http://127.0.0.1:8000/existences/api/demandes/$demandeId/" ;

  final response = await http.get(Uri.parse(url)) ;

  if(response.statusCode == 200){

    String utfResponse = utf8.decode(response.bodyBytes) ;

    Map item = jsonDecode(utfResponse); 

    Prestation prestation = await fetchPrestation(item["prestation"]);
    Client client = await fetchClient(item["client"]); 

    List<String> listeYearMonthDay = item["date"].toString().split("-");
    List<String> listDebHouMinSec = item["heure_debut"].toString().split(":");
    List<String> listFinHouMinSec = item["heure_fin"].toString().split(":");
    List<String> listYMDCreated = item["created_at"].toString().substring(0 , 10).split("-");
    List<String> listHMSCreated = item["created_at"].toString().substring(11 , 19).split(":") ;

    List<int> intlisteYearMonthDay = listeYearMonthDay.map((eleTemp) => int.parse(eleTemp)).toList() ;
    List<int> intlistDebHouMinSec = listDebHouMinSec.map((eleTemp) => int.parse(eleTemp)).toList() ;
    List<int> intlistFinHouMinSec = listFinHouMinSec.map((eleTemp) => int.parse(eleTemp)).toList() ;

    List<int> intlistYMDCreated = listYMDCreated.map((eleTemp) => int.parse(eleTemp)).toList();
    List<int> intListHMSCreated = listHMSCreated.map((eleTemp) => int.parse(eleTemp)).toList();

    Demande demande = Demande(
        
      id: item["id"], 
      client: client, 
      isUrgent: (item['type'] == "urgent") ? true : false,
      prestation: prestation, 
      description: item['description'],
      dateDebut: DateTime(intlisteYearMonthDay[0] , intlisteYearMonthDay[1] , intlisteYearMonthDay[2] , intlistDebHouMinSec[0] , intlistDebHouMinSec[1] , intlistDebHouMinSec[2]), 
      dateFin: DateTime(intlisteYearMonthDay[0] , intlisteYearMonthDay[1] , intlisteYearMonthDay[2] , intlistFinHouMinSec[0] , intlistFinHouMinSec[1] , intlistFinHouMinSec[2]),
      dateRealisation: DateTime(intlistYMDCreated[0] , intlistYMDCreated[1] , intlistYMDCreated[2] , intListHMSCreated[0] , intListHMSCreated[1] , intListHMSCreated[2]),
      addresse: item["localisation"],
      tarifEstime: item["Tarif"] ,
      isConfirmed: item['Confirme'], 
    
    );

    //demande.artisants = await fetchArtisantsForDemande(demande) ; //récuperer liste des artisants qui ont accepté la demande
    //if(demande.isConfirmed) demande.artisant = await fetchArtisant(item['artisan']) ;

    return demande ;

  }else {
    // If the server did not return a 200 OK response, throw an exception
    throw Exception('Failed to load Demande');
  }

}

Future<List<BoiteDialogue>> getDialogues() async{

  List<BoiteDialogue> dialogues = List.empty(growable: true) ;

  List<int> listIds = List.empty(growable: true) ;

  for(int i = 0 ; i < UserData.demandes.length ; i++){

    if( UserData.demandes[i].isConfirmed){

      BoiteDialogue dialogue = BoiteDialogue(
        client: UserData.demandes[i].client, 
        artisant: UserData.demandes[i].artisant! ,
      );

      if(UserData.isClient){

        if(listIds.contains(dialogue.artisant.id)){ //cas particulier , s'il y avait deux rendez vous , avec la mème personne , on doit pas avoir doublait dans la boite de dialogues

          continue ;

        } else {

          listIds.add(dialogue.artisant.id);
          dialogue.messages = await fetchMessagesForDialogue(dialogue) ;
          dialogues.add(dialogue);

        }

      } else {

        if(listIds.contains(dialogue.client.id)){

          continue ;

        } else {

          listIds.add(dialogue.client.id);
          dialogue.messages = await fetchMessagesForDialogue(dialogue) ;
          dialogues.add(dialogue);

        }
      }

    }

  }

  return dialogues ;
}

void initRoute(){

  routes = { //Liste des pages qu'on va déclarer leur routes

    "/" :(context) => const Splash() , //Loading Page

    "/root" :(context) => const FirstPage() , //Première page

    "/choixInscr" :(context) => const ChoixInscription(color: color),

    "/connexion" : (context) => const Connexion(color: color) , //Connexion page
     
    "/inscriptionCli" : (context) =>  const InscrireClient() ,

    "/inscriptionArti" :(context) => InscrireArtisan() ,

  };

}

void routingPrestations(List<Domaine> domaines){

  String routeName ;

  for(int i = 0 ; i < domaines.length ; i++){ //pour chaque page , on va créer une map pour sa route

    routeName = "/homeCli_${domaines[i].id}";//nom de la route vers ce domaine
    
    routes[routeName] = (context) => PrestCliPage(color: color, domaine: domaines[i]) ; //page d'un domaine cliqué

    for(int j = 0 ; j < domaines[i].prestations.length ; j++){

      routeName = "/homeCli_${domaines[i].id}_${domaines[i].prestations[j].id}";//nom de la route
      routes[routeName] = (context) => EnvoiPage(color: color, domaine: domaines[i], prestation: domaines[i].prestations[j])  ; //page d'une prestation cliqué
    
    }

  }
}

void routingUser() async{//Créer tous les routes de user Client

  initRoute() ;

  List<Domaine> domaines = await fetchlistDomaines() ;

  routes['/homeCli'] = (context) => HomePageClient(color: color, domaines: domaines) ; //page d'acceuil de client
  routes['/homeArti'] =(context) => const HomePageArtisan(color: color) ;
  routes['/demandeCli'] = (context) => const ListeDemande(color: color) ; //Liste de demande ;
  routes['/boiteCli'] = (context) => BoiteDialogueCli(color: color, boites: UserData.dialogues) ; //Liste de disscussions ;
  routes['/photoPro'] =(context) => PhotoPro(color: color);

  routingPrestations(domaines); //ajouter les pages de chaque prestation

}

void main() async {

  //Client client = Client(id : 1 ,nom: "Tati", prenom: "Youcef", compte: "hvfsk@gmail.com", imagePath: "Images/20471174.jpg") ;

  initRoute(); //initialiser les première pages de l'application

  routingUser();
  
  runApp(const Afriha());

}

class Afriha extends StatelessWidget { //Notre Application

  const Afriha({super.key});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(

      create:(context) => UserData() , //Créer des datas préts à changer pendant le code
      
      child: MaterialApp( //éxécuter l'application
  
        initialRoute: "/", //First Page to be loaded (en réalité , c'est la page de chargement Splash.dart)
        routes: routes , //tout les routes affectés , pour le moment c'est les premières pages et cel de client
        
      ),

    );
  }
}

