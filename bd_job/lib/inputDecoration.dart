import 'package:flutter/material.dart';

class CustomInputDecoration {
  static InputDecoration buildInputDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(),
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      contentPadding: EdgeInsets.zero,
    );
  }
}
