import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loginsignup/model/places.dart';
import 'package:loginsignup/provider/user_places_provider.dart';
import 'package:loginsignup/widgets/image_input_widget.dart';
import 'package:loginsignup/widgets/location_input.dart';

class AddPlacesScreen extends ConsumerStatefulWidget {
  const AddPlacesScreen({super.key});

  @override
  ConsumerState<AddPlacesScreen> createState() {
    return _AddPlacesState();
  }
}

class _AddPlacesState extends ConsumerState<AddPlacesScreen> {
  final _titleTextEditingController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? location;

  void _savePlace() {
    final enteredText = _titleTextEditingController.text;

    if (enteredText.isEmpty|| _selectedImage==null|| location==null) {
      return;
    }

    ref.read(userPlacesProvider.notifier).addPlace(enteredText,_selectedImage!,location!);

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleTextEditingController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              controller: _titleTextEditingController,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(
              height: 16,
            ),
            ImageInputWidget(
              onSelectImage: (File image) {
                _selectedImage = image;
              },
            ),
            const SizedBox(height: 16,),
             LocationInputWidget(selectLocation: (location){
               this.location=location;

            },),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(
              onPressed: () {
                _savePlace();
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Place'),
            ),
          ],
        ),
      ),
    );
  }
}
