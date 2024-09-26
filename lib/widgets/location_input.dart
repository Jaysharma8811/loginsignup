import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:loginsignup/model/places.dart';
import 'package:loginsignup/views/map_screen.dart';

class LocationInputWidget extends StatefulWidget {
  const LocationInputWidget({super.key, required this.selectLocation});

  final void Function(PlaceLocation location) selectLocation;

  @override
  State<LocationInputWidget> createState() {
    return _LocationInputWidgetState();
  }
}

class _LocationInputWidgetState extends State<LocationInputWidget> {
  PlaceLocation? pickedLocation;
  var isGettingLocation = false;

  // String get locationImage{
  //   if(pickedLocation==null){
  //     return '';
  //   }
  //   final lat =pickedLocation!.lat;
  //   final lng= pickedLocation!.lng;
  //   return "https://maps.googleapis.com/maps/api/staticmap?center$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:S%7C$lat,$lng&key=AIzaSyAtR8fE7XREmyghhWcube5qkTUreTXvWAA";
  // }

 Future <void> _savePlace(double lat, double lng)async{

   final url = Uri.parse(
       "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyAtR8fE7XREmyghhWcube5qkTUreTXvWAA");
   final response = await http.get(url);
   final resData = json.decode(response.body);
   final address = resData['results'][0]['formatted_address'];

   if (kDebugMode) {
     print("address:$address");
   }

   setState(() {
     pickedLocation = PlaceLocation(lat: lat, lng: lng, address: address);
     isGettingLocation = false;
   });

   widget.selectLocation(pickedLocation!);
  }



  Future<void> _getCurrentLocation() async {
    Location location = Location();

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
    setState(() {
      isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    _savePlace(lat, lng);
  }

  void _selectOnMap() async {
    final pickedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => const MapScreen(),
      ),
    );
    if(pickedLocation==null){
      return;
    }

    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location is chosen yet!',
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
      textAlign: TextAlign.center,
    );
    if (pickedLocation != null) {
      previewContent = Text(
        pickedLocation!.address,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
        textAlign: TextAlign.center,
      );
    }

    if (isGettingLocation == true) {
      previewContent = const CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
            height: 170,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
            ),
            child: previewContent),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get current location'),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on map'),
            ),
          ],
        ),
      ],
    );
  }
}
