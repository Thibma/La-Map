import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class MainElevatedButton extends StatelessWidget {
  const MainElevatedButton(
      {Key? key,
      required this.onPressed,
      required this.textButton,
      this.isMainButton = true})
      : super(key: key);

  final Function() onPressed;
  final String textButton;
  final bool isMainButton;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.all(15.0)),
          backgroundColor: MaterialStateProperty.all(
              isMainButton ? primaryColor : lightColor),
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
