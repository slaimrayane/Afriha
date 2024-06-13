// ignore_for_file: file_names

import 'package:afriha_app/Disscussion.dart';
import 'package:afriha_app/ListeArtisant.dart';
import 'package:afriha_app/ListeInterventions.dart';
import 'package:afriha_app/Notifications.dart';
import 'package:afriha_app/main.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ToolBar{ //Cette classe à créer des widgets répititifs et d'autres outils utiles

  static int coulButtonStatic(int color){
    if(color >= 0xFF2196F3) return 0xFFFFFFFF ;
    return 0xFF000000 ;
  }

  static int coulTextStatic(int color){
    if(color >= 0xFF2196F3) return 0xFF000000 ;
    return 0xFFFFFFFF ;
  }

  static Widget shortLoadingScreen(int backgroundColor , int color){

    return Container(

      decoration: BoxDecoration(
        color:  Color(backgroundColor),
      ),

      width: double.infinity,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          SpinKitFoldingCube(
            color: Color(color),
          )

        ],

      ),

    );

  }

  static AppBar topAppBar(String description , int color , BuildContext context , Future<void> Function() refresher){

    return AppBar( //Header

      toolbarHeight: 45,

      title: Row( //Row of 4 objects
      
        mainAxisAlignment: MainAxisAlignment.start,
        
        children: [

          const SizedBox(width: 30), //10
      
          /*IconButton(
          
            onPressed: () => {},
                        
            style : ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(0),
              //backgroundColor: Color(color).withOpacity(0.2) ,
              elevation: 0.0 ,
            ),
              
            icon:Image.asset(
              "Images/Menu.png",
              width: 20,
              height: 20,
            ),
                        
          ),*/

          const SizedBox(width: 10),

          Expanded(
      
            child: Container(

              padding: const EdgeInsets.symmetric(horizontal: 5 , vertical: 5),
              margin: const EdgeInsets.symmetric(horizontal: 5),
        
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Color(color),
              ),

              child: Text( //titre
                description ,
                          
                maxLines: 1,   
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
                          
                style: TextStyle(
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0, 
                  color : Colors.white ,
                  shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
                ),
                          
              ),
            ),
      
          ),
      
          IconButton( //Notification Button
                
            onPressed: () {

              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (BuildContext context) => NotificationsPage(refreshLastPage: refresher),
                )
              );

            },
      
            style : ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(0),
              //backgroundColor: Color(color).withOpacity(0.2) ,
              elevation: 0.0 ,
            ),
              
            icon: Image.asset(

              ( UserData.notifications.isEmpty ||  UserData.notifications[0].vue) ?
              "Images/NotificationOff.png" : 
              "Images/NotificationOn.png",

              width: 20,
              height: 20,
            ),
            
          ),
      
          const SizedBox(width:5.0) ,
          
          IconButton( //Account Button
                
            onPressed: () {
              
              Navigator.pushNamed(context , "/photoPro") ;

            },
      
            style : ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(0),
              //backgroundColor: Color(color).withOpacity(0.2) ,
              elevation: 0.0 ,
            ),
              
            icon: CircleAvatar(
              backgroundImage: UserData.isClient ? AssetImage(UserData.client.imagePath) : AssetImage(UserData.artisan.imagePath),
              radius: 13,
            ),
            
          ),
        ],
      ),

      elevation: 0.0 ,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white , 
      titleSpacing: 5.0,
      leading: null,
      automaticallyImplyLeading: false,
      
    );
  }

  static Widget bottomNavBar(int indexActive , int color , BuildContext context){ //Crée la navigation bas selon le paramètre donnée : {1 , 2 , 3} , si 1 alors Home sera active

    String imgHome = "Images/Home0.png" ;
    String imgDemande = "Images/Demande0.png" ;
    String imgMessage = "Images/Message0.png" ;

    switch(indexActive){
      case 1:
        imgHome = imgHome.replaceFirst("0", "1"); //Example : si case 1 : "Images/Home0" ---> "Images/Home1" Image changed !! ;
      break ;

      case 2:
        imgDemande = imgDemande.replaceFirst("0", "1") ;
      break ;

      case 3:
        imgMessage = imgMessage.replaceFirst("0", "1");
      break ;
    }

    return BottomAppBar(
        
      color: Colors.white, //Couleur de paramètre de première page
      surfaceTintColor: Colors.white,
      padding:const EdgeInsets.all(0),
      height: 55.0,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [ //3 boutons de bas

          IconButton(

            style: ElevatedButton.styleFrom(
              backgroundColor: imgHome.contains('1') ? Color(color).withOpacity(0.5) : Colors.transparent ,
            ),
            
            icon: Image.asset(
              imgHome,
              width: 20,
              height: 20,
            ),

            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('')) ; //enlever tous les pages empilées
              UserData.isClient ? Navigator.pushNamed(context, '/homeCli') : Navigator.pushNamed(context, '/homeArti');
            },

          ),

          IconButton(

            style: ElevatedButton.styleFrom(
              backgroundColor: imgDemande.contains('1') ? Color(color).withOpacity(0.5) : Colors.transparent ,
            ),

            icon: Image.asset(
              imgDemande,
              width: 20,
              height: 20,
            ),


            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('')) ;
              Navigator.pushNamed(context, "/demandeCli") ;
            },
          ),

          IconButton(

            style: ElevatedButton.styleFrom(
              backgroundColor: imgMessage.contains('1') ? Color(color).withOpacity(0.5) : Colors.transparent ,
            ),

            icon: Image.asset(
              imgMessage,
              width: 20,
              height: 20,
            ),

            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('')) ;
              Navigator.pushNamed(context, "/boiteCli") ;
            },
          ),

        ],
      ),
    );

  }

}

class UserData extends ChangeNotifier{

  static bool isClient = false ;
  static Client client = Client(id: -1, idUser: -1 ,numTel: 000, nomUtilisateur: "nullUser", compte: "NullCompte@com", imagePath: "20471174.jpg");
  static Artisant artisan = Artisant(id: -1, idUser: -1  ,numTel: 000, nomUtilisateur: "nullUser",compte: "NullCompte@com",  notation: Notation(notation: 0, nbrNota: 0), imagePath: "Images/20471174.jpg" , status: false);
  
  static List<Demande> demandes = List.empty(growable: true) ;
  static List<BoiteDialogue> dialogues = List.empty(growable: true) ;
  static List<Notiification> notifications = List.empty(growable: true) ;

  void setClient(Client client){
    UserData.isClient = true ;
    UserData.client = client;
    notifyListeners();
  }

  void setArtisant(Artisant artisan){
    UserData.isClient = false ;
    UserData.artisan = artisan;
    notifyListeners();
  }

  void setStatus(bool status){
    artisan.status = status ;
    notifyListeners();
  }

  void setList(List<Demande> listeDemande){
    demandes = List.empty(growable: true) ;
    UserData.demandes.addAll(listeDemande);
    notifyListeners();
  }

  void setDialogues(List<BoiteDialogue> dialogues){
    UserData.dialogues = dialogues ;
    notifyListeners() ;
  }

  void setNoti(List<Notiification> notis){
    notifications = notis ;
    notifyListeners() ; //how ironic we notify in this method , haha
  }

  void updateRefresh(){ //si il y avait un changement hors de Provider , ce refresher est utile pour créer des mis à jour pour les pages
    notifyListeners() ;
  }

  void addDemande(Demande demande){
    UserData.demandes.add(demande);
    notifyListeners();
  }

  void deleteDemande(Demande demande){
    demandes.remove(demande) ;
    notifyListeners();
  }

}

class Client{ //classe client

  String nomUtilisateur ;
  String compte ;
  String imagePath ;
  int numTel ;
  int id ;

  int idUser ; //pour messagerie

  Client({required this.id , required this.idUser , required this.numTel , required this.nomUtilisateur , required this.compte , required this.imagePath}) ;

}

class Notation{

  double notation ;
  int nbrNota ;

  Notation({required this.notation , required this.nbrNota}) ;

  void addNotation(double notaClient){
    nbrNota++ ;

    notation = (notation + notaClient) / nbrNota ;
  }

}

class Artisant{

  String nomUtilisateur ;
  bool status ; //true ssi l'artisan peut accepter des demandes urgents
  String compte ;
  int numTel ;
  String imagePath ;
  Notation notation ;
  int id ;

  int idUser ; //pour messagerie

  List<Commentaire> interventions = List.empty(growable: true) ;


  Artisant({required this.nomUtilisateur, required this.numTel ,  required this.compte ,  required this.id , required this.status, required this.imagePath , required this.notation , required this.idUser}) ;

  Widget rowElementDemande(int color , BuildContext context , Function(Artisant , BuildContext) confirmerRDV){ //pour la liste de demande
    
    return Container(

      padding:const EdgeInsets.symmetric(vertical : 20.0 , horizontal: 20.0),
      margin:const EdgeInsets.fromLTRB(40, 30, 40, 30),
      
      decoration: BoxDecoration(
    
        borderRadius: BorderRadius.circular(20.0),
        color: Color(ToolBar.coulButtonStatic(color)),
        boxShadow:const [BoxShadow(
          color: Color(0x0F000000),
          spreadRadius: 2.0,
          offset: Offset(2.0, 2.0),
        )],
    
      ),

      child: Column( 
      
        children: [
      
          Row( //all elements
          
            children: [
              
              CircleAvatar( //Photo de Profil
                backgroundImage: AssetImage(imagePath),
                radius: 30,
              ),
          
              const SizedBox(width: 10) ,
          
              Expanded(
          
                child: Column( //Name + Notation
          
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
          
                  children: [
          
                    Text( //nom
                      nomUtilisateur,
                    
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0, 
                        color : Color(ToolBar.coulTextStatic(color)) ,
                      ),
                    ),
          
                    Row( //Notation : Star + Notation + NbrNota
          
                      children: [
          
                        const SizedBox(
      
                          width: 20,
                          height: 30,
      
                          child:  Icon(
                            Icons.star,
                            color: Colors.amber ,
                          ),
                        ),
          
                        const SizedBox(width: 5) ,
          
                        Text( //Notation + Nbr
                          "${notation.notation}(${notation.nbrNota})",
                        
                          style:const TextStyle(
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0, 
                            color : Colors.amber ,
                          ),
                        ),
          
                      ],
                    )
          
          
                  ],
                )
              ),
      
            ],
          ),
      
          const SizedBox(height : 20) ,
      
          SizedBox(

            width: 200,

            child: Column(
                  
              children: [
                  
                ElevatedButton( //Confimation
                
                  onPressed: () {
                    confirmerRDV(this , context) ;
                  },
                        
                  style:ElevatedButton.styleFrom(
                    backgroundColor: Colors.green ,
                  ),
                
                  child:const Row(

                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                
                      Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                
                      SizedBox(width : 5),
                
                      Text( //confirmer
                        "Confirmer",

                        textAlign: TextAlign.center,
                      
                        style: TextStyle(
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0, 
                          color : Colors.white ,
                        ),
                      ),
                
                    ],
                  ),
                
                ),
                  
                const SizedBox(height: 5) ,
                  
                ElevatedButton( //Ses commentaires
                
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (BuildContext context) => Interventions(artisant: this),
                      )
                    );
                  },
                        
                  style:ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300] ,
                  ),
                
                  child:const Row(

                    mainAxisAlignment: MainAxisAlignment.center,
                    
                    children: [
                
                      Icon(
                        Icons.list,
                        color: Colors.black,
                      ),
                
                      SizedBox(width : 5),
                
                      Text( //ktiba
                        "ses interventions",

                        textAlign: TextAlign.center,
                      
                        style: TextStyle(
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0, 
                          color : Colors.black ,
                        ),
                      ),
                
                    ],
                  ),
                
                ),
                  
              ],
            ),
          ),
      
      
        ],
      ),
    );

  }

}

class Domaine{ //classe domaine de prestation

  String imgPath ;
  String name ;
  int id;
  List<Prestation> prestations ;

  Domaine({required this.imgPath , required this.name ,required this.prestations , required this.id}) ;

  Widget itsWidget(BuildContext context){

    return IconButton(

      onPressed: () {
        Navigator.pushNamed(context, "/homeCli_$id");
      },

      icon: Card( 

        color:const Color(color).withOpacity(0.6),
        semanticContainer: false,

        elevation: 10,

        child: Padding(
          padding: const EdgeInsets.all(10.0),

          child: SizedBox(

            width: 90,

            child: Column(
              children: [
                  
                SizedBox(
                  width: 70.0,
                  child: Image.asset(imgPath)
                ),
            
                const SizedBox(height: 5) ,
                  
                Container(
            
                  padding: const EdgeInsets.symmetric(horizontal: 5 , vertical: 5),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
            
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  ),
            
                  child: Text(
                    name ,
                    style:const TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0, 
                      overflow: TextOverflow.ellipsis,
                  
                    ),
            
                    maxLines: 1,
                    
                  ),
                ) ,
              ]
            ),
          ),
        ),
      ),
    );
  }

  List<Prestation> getList(){
    return prestations ;
  }
}

class Prestation{

  int id ;
  Domaine domaine ;
  String nom ;
  double tarifEstime ;
  String dureeEstime ;
  
  Prestation({required this.id , required this.nom , required this.tarifEstime , required this.dureeEstime , required this.domaine}) ;

  Widget itsButton(BuildContext context){ //Méthode retourne un boutton fonctionnel de cette prestation

    return Container(

      padding:const EdgeInsets.all(10.0),
      
      child: ElevatedButton(

        onPressed: (){
          Navigator.pushNamed(context, "/homeCli_${domaine.id}_$id");
        },
      
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 30.0 , vertical: 20.0) ,
          backgroundColor: Colors.white,
          fixedSize: const Size.fromWidth(double.infinity) , 
        ),
      
        child: Text( //Nom de prestation
        
          nom ,
          
          overflow: TextOverflow.fade,
          textAlign: TextAlign.center,
                
          style: TextStyle(
            fontFamily: "Nunito",
            fontSize: 16.0 ,
            color: Colors.black ,
            fontWeight: FontWeight.w600,
            shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),

          ),
                
        ),
      ),
    
    );
  }

  void setDomaine(Domaine domaine){
    this.domaine = domaine ;
  }

}

class Demande{

  int id ;

  Client client ;
  bool isUrgent ;
  Prestation prestation ;

  String description ;
  DateTime dateDebut ;
  DateTime dateFin ;
  DateTime dateRealisation ;
  String addresse ;

  double tarifEstime ;

  bool isConfirmed ; 
  Artisant? artisant ;
  Commentaire? commentaire ;

  List<Artisant> artisants = List.empty(growable: true);

  Demande({required this.id , required this.description , required this.client, required this.isUrgent , required this.prestation , required this.dateDebut , required this.dateFin , required this.dateRealisation , required this.tarifEstime , required this.addresse , required this.isConfirmed}) ;

  Widget rowElement(bool isDomaine , int color){ //retourne une ligne d'affichage soit domaine wella prestation

    String description = (isDomaine) ? "Domaine : ${prestation.domaine.name}" : "Prestation : ${prestation.nom}" ;

    return Row( //Image + Domaine/Prestation

      children:[

    
        Image.asset("Images/tag.png"),
        

        const SizedBox(width: 5.0),
        
        Expanded(

          child: Text( //titre
            description ,

            textAlign: TextAlign.center,
          
            style:const TextStyle(
              fontFamily: "Nunito",
              fontWeight: FontWeight.w700,
              fontSize: 16.0, 
              color : Colors.white ,
            ),
                        
          ),
        ),

      ],

    );
     
  }

  Widget itsWidgetForClient(int color , BuildContext context){ //routourne tous détail de demande avec le bouton qui consulte liste de ses artisants

    String dateDebut = "${this.dateDebut.day < 10 ? "0${this.dateDebut.day}" : this.dateDebut.day}/${this.dateDebut.month < 10 ? "0${this.dateDebut.month}" : this.dateDebut.month}/${this.dateDebut.year} à ${this.dateDebut.hour < 10 ? "0${this.dateDebut.hour}" : this.dateDebut.hour}h${this.dateDebut.minute < 10 ? "0${this.dateDebut.minute}" : this.dateDebut.minute}min" ;
    String dateRealisation = "${this.dateRealisation.day < 10 ? "0${this.dateRealisation.day}" : this.dateRealisation.day}/${this.dateRealisation.month < 10 ? "0${this.dateRealisation.month}" : this.dateRealisation.month}/${this.dateRealisation.year} à ${this.dateRealisation.hour < 10 ? "0${this.dateRealisation.hour}" : this.dateRealisation.hour}h${this.dateRealisation.minute < 10 ? "0${this.dateRealisation.minute}" : this.dateRealisation.minute}min" ;

    return Container( //Domaine + prestation + image + infos
              
                
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
    
    
      child: Container(
      
        padding:const EdgeInsets.symmetric(vertical : 10.0 , horizontal: 10.0),
        width: double.infinity,
      
        decoration: BoxDecoration(
      
          borderRadius: BorderRadius.circular(20.0),
          color: Color(color) ,
      
        ),
      
        child :Column(
      
          crossAxisAlignment: CrossAxisAlignment.start,
      
          children:[
            
            Row( //Image + Domaine/Prestation
              
              children: [
      
                SizedBox( //Image
                  height: 80.0,
                  child: Image.asset(prestation.domaine.imgPath),
                ),
      
                const SizedBox(width : 10.0),
      
                Expanded(
      
                  child: Column( //Domaine fou9ou prestation
                  
                    crossAxisAlignment: CrossAxisAlignment.start,
                  
                    children: [
                      rowElement(true , color), //afficher le domaine 
                      const SizedBox(height: 10.0),
                      rowElement(false , color), //afficher la prestation
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
      
            Center(
              child: Container(//Détails
              
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
            ),
      
            const SizedBox(height: 10.0),
      
            Text(//Tarif estimé
              "Tarif estimé : ${tarifEstime}0 Da",
            
              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w600,
                fontSize: 14.0, 
                color : Colors.white ,
                shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
              ),
            ),
      
            const SizedBox(height: 5.0),
      
            Text(//Durée estimée
              "Durée estimée : ${prestation.dureeEstime.substring(0 , 6).replaceFirst(":", " heures et ").replaceFirst(":", " minutes .")}",
      
                textAlign: TextAlign.center,
      
                style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w600,
                fontSize: 14.0, 
                color : Colors.white ,
                shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
              ),
            ),
      
            const SizedBox(height: 5.0),
      
            (isUrgent && !isFinished() && !isConfirmed) ? Text( //Urgence
      
              "Cette demande est Urgente !!",
      
              textAlign: TextAlign.center,
            
              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w600,
                fontSize: 20.0, 
                color : Colors.white ,
                shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
              ),
              
      
            ) : const SizedBox(height: 0) ,
      
            const SizedBox(height: 5.0),
      
            Text( //Date Prise
              "Date voulue : $dateDebut" ,

              textAlign: TextAlign.center,
      
              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w600,
                fontSize: 14.0, 
                color : Colors.white ,
                shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
              ),
            ),
      
            const SizedBox(height: 5.0),
      
            Text( //Location prise
      
              "Location prise : $addresse",
      
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            
      
              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w600,
                fontSize: 12.0, 
                color : Colors.white ,
                shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
              ),
      
            ),
      
            const SizedBox(height: 15.0),
      
            (!isConfirmed && !isFinished()) ? Center(
      
              child: Column(
              
                crossAxisAlignment: CrossAxisAlignment.center,
              
                children: [
              
                  ElevatedButton( //Liste des artisants bouton
                  
                    onPressed: () => {
                  
                      Navigator.push(context, 
                      MaterialPageRoute(
                        builder: (BuildContext context) => ListArtisant(artisants: artisants, color: color , demande: this),
                      ))
                  
                    },
                  
                    style: ElevatedButton.styleFrom(
                  
                      backgroundColor:  Colors.white,
                      padding:const EdgeInsets.symmetric(horizontal: 30.0 , vertical: 20.0),
                  
                      side:const BorderSide(
                        style: BorderStyle.solid  ,
                        color: Colors.transparent ,
                        width: 4 ,
                      ),
                  
                    ),
                  
                    child: Text(
                      "liste d'artisants acceptés",
                    
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0, 
                        color : Colors.black ,
                        shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
                      ),
                  
                    ),
                  ),
                
                  /*const SizedBox(height: 10) ,
      
                  ElevatedButton( //Supprimer la demande
              
                    onPressed: () {
                      userData.deleteDemande(this);
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/demandeCli");
                    },
                  
                    style: ElevatedButton.styleFrom(
              
                      backgroundColor:  Colors.red[300],
                      padding:const EdgeInsets.symmetric(horizontal: 30.0 , vertical: 20.0),
                  
                      side:const BorderSide(
                        style: BorderStyle.solid  ,
                        color: Colors.transparent ,
                        width: 4 ,
                      ),
              
                    ),
                  
                    child:const Text(
                      "Annuler la demande",
                    
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0, 
                        color : Colors.white ,
                      ),
                  
                    ),
                  ),*/
              
                ],
              
              ),
            ) : const SizedBox(height: 0), //else , no need these buttons (we gonna add after info of RDV)
      
            isConfirmed ? Text( //Rendez vous
      
              "Un rendez vous a été confirmé avec ${artisant!.nomUtilisateur}",
      
              textAlign: TextAlign.center,
      
              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w600,
                fontSize: 18.0, 
                color : Colors.white ,
                shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
              ),
      
            ) : const SizedBox(height: 0),
      
            isFinished() ? Text( //Date Prise
      
              "Créé le : $dateRealisation",

              textAlign: TextAlign.center,
      
              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w600,
                fontSize: 16.0, 
                color : Colors.white ,
                shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
              ),
      
            ) : const SizedBox(height: 0),
      
          ],
        ),
      
      ),
    
    );
  }

  Widget itsWidgetForArtisant(int color , BuildContext context , Function(Demande , BuildContext) createDemandeAcceptee ){ //routourne tous détail de demande avec le bouton qui consulte liste de des demandes des clients

    String dateDebut = "${this.dateDebut.day < 10 ? "0${this.dateDebut.day}" : this.dateDebut.day}/${this.dateDebut.month < 10 ? "0${this.dateDebut.month}" : this.dateDebut.month}/${this.dateDebut.year} à ${this.dateDebut.hour < 10 ? "0${this.dateDebut.hour}" : this.dateDebut.hour}h${this.dateDebut.minute < 10 ? "0${this.dateDebut.minute}" : this.dateDebut.minute}min" ;
    String dateFin = "${this.dateFin.day < 10 ? "0${this.dateFin.day}" : this.dateFin.day}/${this.dateFin.month < 10 ? "0${this.dateFin.month}" : this.dateFin.month}/${this.dateFin.year} à ${this.dateFin.hour < 10 ? "0${this.dateFin.hour}" : this.dateFin.hour}h${this.dateFin.minute < 10 ? "0${this.dateFin.minute}" : this.dateFin.minute}min" ;
    String dateRealisation = "${this.dateRealisation.day < 10 ? "0${this.dateRealisation.day}" : this.dateRealisation.day}/${this.dateRealisation.month < 10 ? "0${this.dateRealisation.month}" : this.dateRealisation.month}/${this.dateRealisation.year} à ${this.dateRealisation.hour < 10 ? "0${this.dateRealisation.hour}" : this.dateRealisation.hour}h${this.dateRealisation.minute < 10 ? "0${this.dateRealisation.minute}" : this.dateRealisation.minute}min" ;


    return Container(
              
                
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
    
      child: Container(
      
        padding:const EdgeInsets.symmetric(vertical : 10.0 , horizontal: 10.0),
        width: double.infinity,
      
        decoration: BoxDecoration(
      
          borderRadius: BorderRadius.circular(20.0),
          color: Color(color) ,
      
        ),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,

          children:[

            Row( //Photo de profil , Nom , date de création
              
              children: [
      
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(client.imagePath),
                ),
      
                const SizedBox(width : 10.0),
      
                Expanded(
      
                  child: Column( //Domaine fou9ou prestation
                  
                    crossAxisAlignment: CrossAxisAlignment.start,
                  
                    children: [

                      Text( //nom de l'utlisateur
                        client.nomUtilisateur ,
                      
                        maxLines: 1,   
                        overflow: TextOverflow.ellipsis,
                      
                        style:const TextStyle(
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0, 
                          color : Colors.white ,
                        ),
                                    
                      ),
      
                      const SizedBox(height: 10.0),

                      Text( //date de création
                        dateRealisation ,
                      
                        maxLines: 1,   
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      
                        style:const TextStyle(
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0, 
                          color : Colors.white ,
                        ),
                                    
                      ),
                    ],
                  
                  ),
                )
      
              ],
      
            ),

            const SizedBox(height: 10.0),

            Text( //description
              "-> $description",

              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            
              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w600,
                fontSize: 18.0, 
                color : Colors.white ,
                shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
              ),
            ),


            const Divider( //un fil qui s'affiche comme décoration
              height: 40.0,
              thickness: 5,
              color: Colors.white,
            ),


            Center(//Détails
              child: Container(//Détails
              
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
            ),
      
            const SizedBox(height: 10.0),

            Text( //Prestation
              "Prestation : ${prestation.nom}",

              textAlign: TextAlign.center,
            
              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w600,
                fontSize: 18.0, 
                color : Colors.white ,
                shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
              ),
            ),

            const SizedBox(height: 10.0),

            Text( //Tarif estimé
              "gain du travail : \n $tarifEstime Da",

              textAlign: TextAlign.center,
            
              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w600,
                fontSize: 16.0, 
                color : Colors.white ,
                shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
              ),
            ),

            const SizedBox(height: 5.0),

            Text( //Date voulue par le client

              "Date demandée : $dateDebut\n libre jusqu'à $dateFin",

              textAlign: TextAlign.center,
            
              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w600,
                fontSize: 16.0, 
                color : Colors.white ,
                shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
              ),

            ),

            const SizedBox(height: 5.0),

            (isUrgent && !isFinished() && !isConfirmed) ? Text( //Urgence

              "Cette demande est Urgente !!",

              textAlign: TextAlign.center,
            
              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w600,
                fontSize: 20.0, 
                color :const Color.fromARGB(255, 255, 196, 196) ,
                shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
              ),

            ) : const SizedBox(height: 0) ,

            const SizedBox(height: 5.0),

            Text( //Location prise

              "Location prise : $addresse",

              textAlign: TextAlign.center,

              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            

              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w600,
                fontSize: 12.0, 
                color : Colors.white ,
                shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
              ),

            ),

            const SizedBox(height: 15.0),

            (!isConfirmed && !isFinished()) ? Center( //option boutons

              child: Column(
              
                crossAxisAlignment: CrossAxisAlignment.center,
              
                children: [
              
                  (!contains(UserData.artisan)) ? ElevatedButton( //Accepter la demande ssi l'artisan n'existe pas encore dans la liste
                  
                    onPressed: () {
                      
                      createDemandeAcceptee(this , context); 

                      sendNotification(client.idUser, "${UserData.artisan.nomUtilisateur} a accepté l'un de vos demandes.");
                  
                    },
                  
                    style: ElevatedButton.styleFrom(
                  
                      backgroundColor:  Colors.green[200],
                      padding:const EdgeInsets.symmetric(horizontal: 30.0 , vertical: 20.0),
                  
                      side:const BorderSide(
                        style: BorderStyle.solid  ,
                        color: Colors.transparent ,
                        width: 4 ,
                      ),
                  
                    ),
                  
                    child: Text(
                      "accepter la demande",
                    
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0, 
                        color : Colors.black ,
                        shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
                      ),
                  
                    ),
                  ) : const SizedBox(height: 0),
                
                  const SizedBox(height: 10) ,

                  (contains(UserData.artisan)) ? ElevatedButton( //Annuler l'acceptance
              
                    onPressed: () {
                      //supprimer demandeAccepte dans le backend , not ready yet
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/demandeCli");
                    },
                  
                    style: ElevatedButton.styleFrom(
              
                      backgroundColor:  Colors.red[300],
                      padding:const EdgeInsets.symmetric(horizontal: 30.0 , vertical: 20.0),
                  
                      side:const BorderSide(
                        style: BorderStyle.solid  ,
                        color: Colors.transparent ,
                        width: 4 ,
                      ),
              
                    ),
                  
                    child: Text(
                      "Annuler l'invitation de demande",
                    
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0, 
                        color : Colors.white ,
                        shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
                      ),
                  
                    ),
                  
                  ) : const SizedBox(height: 0),
              
                ],
              
              ),
            ) : const SizedBox(height: 0), //else , no need these buttons (we gonna add after info of RDV)

            isConfirmed ? Text( //Rendez vous

              "Un rendez vous a été confirmé avec ${client.nomUtilisateur}",

              textAlign: TextAlign.center,

              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w600,
                fontSize: 18.0, 
                color : Colors.white ,
                shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
              ),

            ) : const SizedBox(height: 0),

            isFinished() ? Text( //Date Prise

              "Créé le : \n$dateRealisation",

              textAlign: TextAlign.center,

              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w600,
                fontSize: 16.0, 
                color : Colors.white ,
                shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),
              ),

            ) : const SizedBox(height: 0),

          ],
        ),
      ),
    );
  }

  bool contains(Artisant artisant){ //si la demande contient cet artisant qui a accepté
    List<int> idList = artisants.map((artisant) => artisant.id).toList() ;

    return idList.contains(artisant.id); 
  }

  bool isFinished(){

    if(dateFin.compareTo(DateTime.now()) < 0){
      return true ;
    } else {
      return false ;
    }

  }

}

class Commentaire{

  //Demande initialisé avec un garbage data pour aprés faire un fetch et récupérer la vrai demande
  Demande demande = Demande(id: -1, description: "NULL", client: UserData.client, isUrgent: false, prestation: Prestation(id: -1, nom: "NULL", tarifEstime: 200, dureeEstime: 'null', domaine: Domaine(imgPath: "imgPath", name: "name", prestations: [], id: -1)), dateDebut: DateTime.now(), dateFin: DateTime.now(), dateRealisation: DateTime.now(), tarifEstime: 20, addresse: "addresse", isConfirmed: false);
  String avisClient ;
  double notationClient ;

  Commentaire({required this.avisClient , required this.notationClient}) ;

  Widget itsWidget(){

    return Container(
      
      padding:const EdgeInsets.symmetric(vertical : 20.0 , horizontal: 20.0),
      margin:const EdgeInsets.fromLTRB(20, 10, 20, 10),
      
      decoration: BoxDecoration(
    
        borderRadius: BorderRadius.circular(20.0),
        color: Color(ToolBar.coulButtonStatic(color)),
        boxShadow:const [BoxShadow(
          color: Color(0x0F000000),
          spreadRadius: 2.0,
          offset: Offset(2.0, 2.0),
        )],
    
      ),
    
      child: Column(
    
        children: [
    
          Container(

            padding:const EdgeInsets.symmetric(vertical : 10.0 , horizontal: 10.0),
            width: double.infinity,

            decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(20.0),
              color: const Color(color) ,

            ),

            child: Column(

              children: [

                Row(
    
                  children: [
          
                    CircleAvatar( //Photo de Profil
                      backgroundImage: AssetImage(demande.client.imagePath),
                      radius: 30,
                    ),
                            
                    const SizedBox(width: 10) ,
                            
                    Expanded(
                              
                      child: Column( //Name + Notation
                              
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                              
                        children: [
                              
                          Text( //nom
                            demande.client.nomUtilisateur,
                          
                            style: TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0, 
                              color : Colors.white ,
                              shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),

                            ),
                          ),
                              
                          Row( //Notation : Star + Notation
                              
                            children: [
                              
                              const SizedBox(
                    
                                width: 20,
                                height: 30,
                    
                                child:  Icon(
                                  Icons.star,
                                  color: Colors.white ,
                                ),
                              ),
                              
                              const SizedBox(width: 5) ,
                              
                              Text( //Notation + Nbr
                                '$notationClient',
                              
                                style: TextStyle(
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0, 
                                  color : Colors.white ,
                                  shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),

                                ),
                              ),
                              
                            ],
                          )
                              
                              
                        ],
                      )
                    ),
                  ],
                ) ,
          
                const SizedBox(height: 20),

                Text( //commentaire
                    
                  avisClient.isEmpty ? "Aucun commentaire fait" : "Commentaire : $avisClient",
                    
                  maxLines: 2,      
                  overflow: TextOverflow.ellipsis, 
                  textAlign: TextAlign.start, 
                    
                  style: TextStyle(
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0, 
                    color : Colors.white ,
                    shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)) ,
                  ),
                ),
              ],

            ),
          ),
    
        ],
      ),
      
    );

  }

}

class Message{

  String contenu ;
  bool isSender ;

  Message({ required this.contenu , required this.isSender}) ;

  Widget itsWidget(){

    int color = (isSender) ? 0xFF007DDD : 0xFF000000 ;

    return BubbleNormal(

      text: contenu ,
      isSender: isSender ,
      color:Color(color) ,
      tail: true ,

      textStyle :const TextStyle(

        fontFamily: "Nunito",
        fontWeight: FontWeight.w700,
        fontSize: 17.0, 
        color : Colors.white ,

      ),
    );

  }

}

class BoiteDialogue{

  Client client ;
  Artisant artisant ;

  List<Message> messages = List.empty(growable: true);

  BoiteDialogue({required this.client , required this.artisant});

  bool equals(BoiteDialogue dialogue){

    if(UserData.isClient){
      return artisant.id == dialogue.artisant.id ;
    } 

    return client.id == dialogue.client.id ;

  }

  void addMessage(Message message){
    messages.add(message) ;
  }
  
  Widget itsButton(int color , BuildContext context){

    return ElevatedButton(
    
      onPressed: () {
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (BuildContext context) => Disscussion(color: color, boite: this),
          )
        );
      },
    
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical : 20.0 , horizontal: 20.0),
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(0)
        ),
        
      ),
    
      child: Row( //all elements
      
        children: [
          
          CircleAvatar( //Photo de Profil
            backgroundImage: AssetImage(UserData.isClient ? artisant.imagePath : client.imagePath),
            radius: 30,
          ),
      
          const SizedBox(width: 10) ,
      
          Expanded(
      
            child: Column( //Name + numTel
      
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
      
              children: [
      
                Text( //nom
                  UserData.isClient ? artisant.nomUtilisateur : client.nomUtilisateur,
                
                  style: TextStyle(
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0, 
                    color : Color(ToolBar.coulTextStatic(color)) ,
                  ),
                ),
                        
                Text( //numTel
                  "+213 ${UserData.isClient ? artisant.numTel : client.numTel}",
                
                  style: TextStyle(
      
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0, 
                    color : Colors.grey[700] ,
      
                  ),
                )
      
      
              ],
            )
          ),
      
          const SizedBox(width: 10) ,
      
        ],
      ),
    );

  }

}

class Notiification{

  DateTime date ;
  String notification ;
  bool vue ;

  Notiification({required this.date , required this.notification , required this.vue});

  Widget itsWidget(int color , BuildContext context){

    String date = "${this.date.day < 10 ? "0${this.date.day}" : this.date.day}/${this.date.month < 10 ? "0${this.date.month}" : this.date.month}/${this.date.year}  ${this.date.hour < 10 ? "0${this.date.hour}" : this.date.hour}h${this.date.minute < 10 ? "0${this.date.minute}" : this.date.minute}min" ; //un simple formate date en String (this is not Chatgpt , trust me)


    return Container(
    
      padding:const EdgeInsets.symmetric(vertical : 20.0 , horizontal: 20.0),
      margin:const EdgeInsets.fromLTRB(20, 5, 20, 5),
      
      decoration: BoxDecoration(
    
        borderRadius: BorderRadius.circular(5.0),

        color:vue ? Colors.white : Colors.grey[300],

        boxShadow:const [BoxShadow(
          color: Color(0x0F000000),
          spreadRadius: 2.0,
          offset: Offset(2.0, 2.0),
        )],
    
      ),
    
      child: Row( //all elements
      
        children: [
      
          Expanded(
      
            child: Column( //Date + noti
      
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
      
              children: [
      
                Text( //date
                  date,
                
                  style: TextStyle(
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0, 
                    color : Color(ToolBar.coulTextStatic(color)) ,
                  ),
                ),
                        
                Text( //noti
                  notification,
                
                  style: TextStyle(
      
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0, 
                    color : Colors.grey[700] ,
      
                  ),
                )
      
              ],
            )
          ),
      
      
        ],
      ),
    );
  }


}