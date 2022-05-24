import 'package:flutter/material.dart';

void errorDialog(BuildContext context, String contentText) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Erreur de connexion"),
        content: Text(contentText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          )
        ],
      );
    },
  );
}
