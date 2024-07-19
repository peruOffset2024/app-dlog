

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SubirImagenes extends StatefulWidget {
  const SubirImagenes({super.key});

  @override
  State<SubirImagenes> createState() => _SubirImagenesState();
}

class _SubirImagenesState extends State<SubirImagenes> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> getImgGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No hay imagen');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  
          InkWell(
            onTap: () => getImgGallery(),
            child: Container(
              height: 250,
              width: 350,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: _image != null
                  ? Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 30,
                      ),
                    ),
            ),
          );
          
      
   
  }
}