import 'package:flutter/material.dart';
import 'package:la_map/utils/constants.dart';

class TextFieldLogin extends StatelessWidget {
  TextFieldLogin(
      {Key? key,
      required this.hint,
      required this.icon,
      this.obscureText = false,
      this.changed,
      required this.controller})
      : super(key: key);

  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextEditingController controller;
  final Function(String)? changed;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: primaryColor,
      obscureText: obscureText,
      onChanged: changed,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: primaryColor,
        ),
        filled: true,
        fillColor: Colors.black12,
        labelStyle: const TextStyle(fontSize: 12),
        //contentPadding: const EdgeInsets.only(left: 30, top: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
