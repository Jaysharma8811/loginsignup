import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Location? _pickedLocation;

  Future<void> _getCurrentLocation() async {
    Location location =  Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    print("latitude:${locationData.latitude!} & longitude: ${locationData.longitude!}");


  }

  Future<void> getData() async {
    final url = Uri.parse('http://10.0.2.2:3000/');

    try {
      final response=await http.get(url);
      if(response.statusCode==200){
        print(jsonDecode(response.body));
      }
    }catch(e){
      print('error: $e');

    }


  }
@override
  void initState() {

    super.initState();
    getData();
    _getCurrentLocation();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
        const Text('Welcome!',),
        const SizedBox(height: 30,),
        ElevatedButton(onPressed: (){
          FirebaseAuth.instance.signOut();
        }, child: const Text('Sign out')),

          ],
        ),
      ),
    );
  }
}
