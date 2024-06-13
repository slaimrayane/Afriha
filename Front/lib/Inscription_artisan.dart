// ignore_for_file: must_be_immutable, avoid_print, file_names

import 'dart:async';
import 'dart:math';

import 'package:afriha_app/Classes.dart';
import 'package:afriha_app/NotValidatedArt.dart';
import 'package:afriha_app/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'locationPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InscrireArtisan extends StatefulWidget {

  String addresse = "Adresse" ;
  InscrireArtisan({super.key});

  @override
  State<InscrireArtisan> createState() => _InscrireArtState();
}
  
class _InscrireArtState extends State<InscrireArtisan> {
  
  
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  FilePickerResult? result;
  String? filename = "Diplome";
  PlatformFile? pickedfile;
  TextEditingController control = TextEditingController();
  String hint="Domaine expertise";
  String adress = "Adresse";
  double lat=23;
  double long=12;
  List<String> domExpertises = [];
  List<dynamic> _domaines = [];
  String? _selectedDomaineId;
  
  final String _selectedRole = 'artisan';

  bool isvisible = true;
  bool emptyEntries = true ;
  bool tappedLog = false ;

  void controlEmptiness(){

    if((usernameController.text.isEmpty || passwordController.text.isEmpty ||  
      telephoneController.text.isEmpty || firstnameController.text.isEmpty || lastnameController.text.isEmpty || 
      emailController.text.isEmpty) && !emptyEntries){

      setState(() {
        emptyEntries = true ;
        print("Empty again");
      });

    }

    if(usernameController.text.isNotEmpty && passwordController.text.isNotEmpty && 
    telephoneController.text.isNotEmpty && firstnameController.text.isNotEmpty && lastnameController.text.isNotEmpty && 
    emailController.text.isNotEmpty && emptyEntries){

      setState(() {
        emptyEntries = false ;
        print("notEmpty");
      });

    }
  }

  Future<void> _fetchDomaines() async {

    final url = Uri.parse('http://127.0.0.1:8000/existences/api/domaines/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _domaines = jsonDecode(response.body) as List;
        });
      } else {
        // Handle error if HTTP request fails
        print('Failed to fetch Domaine options');
      }
    } catch (error) {
      // Handle network or server error
      print('Error: $error');
      print('there is a problem');
    }
  }
  
  Future<void> registerUser() async {

    final url = Uri.parse('http://127.0.0.1:8000/api/auth/register/artisan/');

    UserData artisanData = Provider.of<UserData>(context , listen: false);

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
            'role': _selectedRole ,
            'password': passwordController.text,
          },
          
          'latitude':lat,
          'longitude':long,
          'num_phone': telephoneController.text,
          'domaine': _selectedDomaineId,
          'diplome': filename,

        }),
      );

      if (response.statusCode == 201) {
      
        // Registration successful

        print('registration posté') ;

        print(response.body) ;
        Map jsonData = jsonDecode(response.body) ;

        Artisant artisant = Artisant(
          nomUtilisateur: usernameController.text, 
          id: jsonData["id"], 
          idUser: jsonData['user']['id'],
          numTel: jsonData['num_phone'],
          compte: jsonData["user"]['email'],
          imagePath: "Images/20471174.jpg", 
          status: jsonData['status'],
          notation: Notation(notation: jsonData["notation"], nbrNota: 0),
        );

        artisanData.setArtisant(artisant) ; //notify pages

        sendNotification(artisant.idUser, "Bienvenue dans Afriha , ceci est votre premier pas pour faciliter votre vie !");

        List<Notiification> notis =  await fetchNotiForUser() ;

        artisanData.setNoti(notis) ;

        print('User registered successfully!');

        // Navigate to success screen
         
        Timer( Duration(seconds: randomSeconds), () {

          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(
              builder: (BuildContext context) => ApresInscription(isBanned: jsonData['banni']),
            )
          );

        });
           
      } else {
        // Registration failed
        print('Failed to register user. Error: ${response.statusCode}');
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
    }

  }
  
  String getter(){
    debugPrint(widget.addresse);
    return widget.addresse;
  }

  void pickfile() async {
    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );
      if (result != null) {
        setState(() {
          filename = result!.files.first.name;
          pickedfile = result!.files.first;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void affectAddresse(String adr){

    setState(() {
      widget.addresse = adr ;
    });

  }

  void affectLatLong(double lat , double long){
    setState(() {
      this.lat = lat ;
      this.long = long ;
    });
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
              controller: lastnameController,

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
              controller: firstnameController,

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

            SizedBox( //addresse

              width: double.infinity,

              child: ElevatedButton(
                onPressed:() {

                  setState(() {

                    Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context) =>
                      LocationPage(affectAddresse: affectAddresse , affectLatLong: affectLatLong,)));
                  });

                },

                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 9,vertical: 16),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(

                      child: Text(
                        widget.addresse,
                        style: const TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 18,
                          color: Color(0xFF64748B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const Icon(
                      Icons.location_on,
                      color: Colors.black,
                    ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            TextField(//NumTel

              onChanged: (value) => setState(() {
                controlEmptiness();
              }),

              textAlign: TextAlign.left,
              controller: telephoneController ,
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

            SizedBox(//domaines d'expertises

              height: 60,

              child: InputDecorator(
                decoration:InputDecoration(
                  border:OutlineInputBorder(
                    borderSide:const BorderSide(
                      width: 1,
                      color: Colors.black,
                    ) ,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                child: DropdownButton<String>(

                  isExpanded: true,
                  value: _selectedDomaineId,

                  onChanged: (String? value) {
                    setState(() {
                      _selectedDomaineId=value!;
                      controlEmptiness() ;

                    });
                  },

                  items: _domaines.map((domaine) {
                    return DropdownMenuItem<String>(

                      value: domaine['id'].toString(),
                      child: Text(domaine['nom_domaine']),

                    );
                  }).toList(),

                  hint: Text(
                    hint,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontFamily: "Nunito",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  icon:  const Icon(Icons.arrow_downward),

                  underline: Container(),
                  
                  /*
                  items: domExpertises.map((String value) {

                    return DropdownMenuItem<String>(
                      alignment: Alignment.centerLeft,
                      value: value,
                      child: Text(
                        value,
                        style:const TextStyle(
                          fontWeight:FontWeight.bold,
                          color:Colors.black,
                        ),
                      ),
                    );

                  }).toList(),
                  */
                ),
              ),
            ),
            
            const SizedBox(height:8),

            SizedBox(//fichier de diplome

              width: double.infinity,
              child: ElevatedButton(
                onPressed: pickfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 16),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "$filename", // Display filename if available
                        style: const TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 18,
                          color: Color(0xFF64748B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.upload_file,
                      color: Color(0xFF64748B),
                    ),
                  ],
                ),
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

                TextField(//mot de passe

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
                      color: Color(0xFF64748B),
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
                    ) ,
                  ),
                ),
                
                const SizedBox(height:8),
                
                RichText( //droit de l'utilisation
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
                          color: Color(0xFF4642FF),
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
                            color: Color(0xFF4642FF),
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
                            color: Color(0xFF4642FF),
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

                SizedBox(//Accept and get rich
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(

                    onPressed: () {

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
  void initState() {
    super.initState();
    controlEmptiness() ;
    _fetchDomaines(); // Fetch Domaine options when the screen initializes
  }


  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Scaffold(

      appBar: AppBar(
        title: Text(
          "Inscription Artisan",
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
