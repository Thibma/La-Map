import 'package:flutter/material.dart';
import 'package:la_map/utils/constants.dart';

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget(
      {Key? key, required this.hint, this.changed, required this.controller})
      : super(key: key);

  final String hint;
  final TextEditingController controller;
  final Function(String)? changed;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: primaryColor,
      onChanged: changed,
      decoration: InputDecoration(
        hintText: hint,
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

class TextFieldMultiline extends StatelessWidget {
  TextFieldMultiline(
      {Key? key, required this.hint, this.changed, required this.controller})
      : super(key: key);

  final String hint;
  final TextEditingController controller;
  final Function(String)? changed;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: primaryColor,
      onChanged: changed,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.black12,
        labelStyle: const TextStyle(fontSize: 12),
        //contentPadding: const EdgeInsets.only(left: 30, top: 100),
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
