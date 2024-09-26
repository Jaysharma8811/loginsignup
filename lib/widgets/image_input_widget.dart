import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInputWidget extends StatefulWidget {
  const ImageInputWidget({super.key, required this.onSelectImage});
  final void Function(File image) onSelectImage;

  @override
  State<ImageInputWidget> createState() {
    return _ImageInputWidgetState();
  }
}

class _ImageInputWidgetState extends State<ImageInputWidget> {
  File? _selectedImage;

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
    widget.onSelectImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: () {
        _takePicture();
      },
      icon: const Icon(Icons.camera),
      label: const Text('Take a picture'),
    );
    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.2), width: 1),
        ),
        height: 250,
        width: double.infinity,
        alignment: Alignment.center,
        child: content);
  }
}
