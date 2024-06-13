// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class LocationPage extends StatelessWidget {

  final Function(String) affectAddresse ; //fonction qui affecte une addresse à la page d'envoi
  final Function(double , double) affectLatLong ;

  const LocationPage({super.key , required this.affectAddresse , required this.affectLatLong});

  @override
  Widget build(BuildContext context){

    return MaterialApp(

      title: 'Flutter Location Picker',
      debugShowCheckedModeBanner: false,

      home: Scaffold(

        appBar: AppBar(
          title: const Text('Choisir une location'),
          centerTitle: true,
          leading: IconButton(
            icon:const Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            },
            
            ),
        ),

        body: FlutterLocationPicker(
          initZoom: 11,
          minZoomLevel: 5,
          maxZoomLevel: 16,
          trackMyPosition: true,
          searchBarBackgroundColor: Colors.white,
          searchBarHintText: "Recherchez une location...",
          selectedLocationButtonTextstyle: const TextStyle(fontSize: 18),
          mapLanguage: 'fr',
          onError: (e) => print(e),
          selectLocationButtonLeadingIcon: const Icon(Icons.check),
          selectLocationButtonText: "Confirmer la location en cours",

          onPicked: (pickedData) {
            affectAddresse(pickedData.address) ;
            affectLatLong(pickedData.latLong.latitude , pickedData.latLong.longitude) ;
            Navigator.pop(context) ;
          },

          onChanged: (pickedData) {
            affectAddresse(pickedData.address) ;
          },

          showContributorBadgeForOSM: true,
        ),
      ),
    );
  }
}