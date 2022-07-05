import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class MainElevatedButton extends StatelessWidget {
  const MainElevatedButton(
      {Key? key, required this.onPressed, required this.textButton})
      : super(key: key);

  final Function() onPressed;
  final String textButton;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          elevation: MaterialStateProperty.all(5.0),
          padding: MaterialStateProperty.all(EdgeInsets.all(15.0)),
          backgroundColor: MaterialStateProperty.all(primaryColor),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)))),
      child: Text(
        textButton,
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 1.5,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
