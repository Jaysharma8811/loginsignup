import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loginsignup/model/places.dart';
import 'package:loginsignup/views/map_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.places});

  final Places places;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(places.title),
        ),
        body: Stack(
          children: [
            Image.file(
              places.image,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) =>  MapScreen(location: places.location,isSelecting: false ,)),
                  );
                },
                child: Container(
                  height: 150,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    places.location.address,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
