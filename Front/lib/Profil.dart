// ignore_for_file: must_be_immutable, file_names

import 'package:afriha_app/Classes.dart';
import 'package:afriha_app/ProfileEditor.dart';
import 'package:flutter/material.dart';

class PhotoPro extends StatefulWidget {

  int color ;

  PhotoPro({required this.color , super.key});

  @override
  State<PhotoPro> createState() => _PhotoProState();
}

class _PhotoProState extends State<PhotoPro> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Color(widget.color),

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
                      "Votre profil" ,
                        
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
    
      body:ListView(

        children: [

          Container(
          
            width: double.infinity,
            padding: const EdgeInsets.all(40),
          
            child: Column(
          
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
          
              children: [
          
                Center( //PHOTO
          
                  child: IconButton( //Account Button
                      
                    onPressed: () => {},
                          
                    style : ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      //backgroundColor: Color(color).withOpacity(0.2) ,
                      elevation: 0.0 ,
                    ),
                      
                    icon: CircleAvatar(
                      backgroundImage:UserData.isClient ? AssetImage(UserData.client.imagePath) : AssetImage(UserData.artisan.imagePath),
                      radius: 60,
                    ),
                    
                  ),
                ),

                /*
                const SizedBox(height: 10),
          
                Center( //modifier photo de profil

                  child: SizedBox(

                    width: 250,

                    child: ElevatedButton(
                      
                      onPressed: (){}, 
                    
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0 , vertical: 20.0) ,
                        backgroundColor: Colors.black,
                        fixedSize: const Size.fromWidth(double.infinity) , 
                      ),
                    
                      child: Text( 
                      
                        "modifier photo de profil" ,
                              
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
                */

                const Divider(height: 70) ,
          
                Row( //nomUtili
          
                  children: [
          
                    const Text(
                       
                      "nom d'utilisateur : ",
                     
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 20.0 ,
                        color: Colors.white ,
                        fontWeight: FontWeight.w700,
                      ),
          
                    ),
          
                   const SizedBox(width: 10),
          
                    Flexible(
                      child: Text(
                        UserData.isClient ?
                        UserData.client.nomUtilisateur : 
                        UserData.artisan.nomUtilisateur ,
                        
                        style:const TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 20.0 ,
                          color: Colors.white ,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1 ,
                        ),
                                
                      ),
                    ),
                  ],
                ),
              
                const SizedBox(height: 10),
          
                Row( //compte
          
                  children: [
          
                    const Text(
          
                      "compte : ",
          
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 20.0 ,
                        color: Colors.white ,
                        fontWeight: FontWeight.w700,

                      ),
          
                    ),
          
                   const SizedBox(width: 10),
          
                    Flexible(
                      child: Text(
                        UserData.isClient ?
                        UserData.client.compte :
                        UserData.artisan.compte ,
                        
                                
                        style:const TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 20.0 ,
                          color: Colors.white ,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1 ,
                        ),
                                
                      ),
                    ),
          

                  ],
                ),
              
                const SizedBox(height: 10),
          
                !UserData.isClient ? Row( //Statut
          
                  children: [
          
                    const Text(
          
                      "Statut : ",
          
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 20.0 ,
                        color: Colors.white ,
                        fontWeight: FontWeight.w700,
                      ),
          
                    ),
          
                    const SizedBox(width: 10),
          
                    Flexible(
                      child: Text(
                        
                        
                        UserData.artisan.status ? 
                        
                        "accepter les demandes urgentes" :
                        "refuser les demandes urgentes",
                                
                        style: TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 20.0 ,
                          color: !UserData.artisan.status ? Colors.red[600] : Colors.white ,
                          fontWeight: FontWeight.w700,
                        ),
                                
                      ),
                    ),
          
          
                  ],
                  
                ) : const SizedBox(height: 0),
              
                const SizedBox(height: 30),

                Center(

                  child: SizedBox(

                    width: 200,

                    child: ElevatedButton(
                      
                      onPressed: (){
                    
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (BuildContext context) => ProfileEditor(color: widget.color),
                          )
                        );
                    
                      }, 
                    
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0 , vertical: 20.0) ,
                        backgroundColor: Colors.white,
                        fixedSize: const Size.fromWidth(double.infinity) , 
                      ),
                    
                      child: Text( 
                      
                        "modifier" ,
                              
                        style: TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 18.0 ,
                          color: Colors.black ,
                          fontWeight: FontWeight.w600,
                          shadows: List.filled(3 , const Shadow(color: Color.fromARGB(255, 134, 134, 134) , blurRadius: 0.5)),

                        ),
                              
                      ),
                    ),
                  ),
                ),
          
                const SizedBox(height: 10),

                Center(

                  child: SizedBox(
                  
                    width: 200,
                  
                    child: ElevatedButton( //deconnexion
                      
                      onPressed: (){
                        Navigator.popUntil(context, ModalRoute.withName('')) ; //enlever tous les pages empilées
                        Navigator.pushNamed(context, '/') ; //retourner au loading page
                    
                      }, 
                    
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0 , vertical: 20.0) ,
                        backgroundColor: Colors.red[600],
                        fixedSize: const Size.fromWidth(double.infinity) , 
                      ),
                    
                      child: Text( 
                      
                        "se déconnecter" ,
                              
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
        ],
      ),
    
    );
  }
}