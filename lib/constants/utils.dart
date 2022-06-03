import 'package:endterm/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource imageSource) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _image = await _imagePicker.pickImage(source: imageSource);

  if (_image != null){
    return await _image.readAsBytes();
  }
  return 'No image selected';
}

showSnackBar( BuildContext context, String content){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: snackBg,
      duration: const Duration(milliseconds: 1500),
      content: Text(content, style: const TextStyle(color: Colors.white),),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 24, left: 12, right: 12),
    ),
  );
}