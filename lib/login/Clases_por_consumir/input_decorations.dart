import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration inputDecoration(
      {required String hintText,
      required String labelText,
      required Icon icono}) {
    return InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        
        hintText: hintText,
        labelText: labelText,
        prefixIcon: icono);
  }
}
