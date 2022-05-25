import 'package:flutter/material.dart';
import 'package:la_map/utils/constants.dart';
import 'package:get/get.dart';
import 'package:la_map/services/authentication.dart';

void signUpDialog(BuildContext context) async {
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Inscription"),
          contentPadding: EdgeInsets.all(10.0),
          children: [
            Container(
              alignment: Alignment.centerLeft,
              decoration: kBoxDecorationStyleDown,
              height: 60.0,
              child: TextField(
                controller: mailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.black38),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(Icons.email, color: Colors.black87),
                    hintText: 'Adresse mail',
                    hintStyle: kHintTextStyle),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              decoration: kBoxDecorationStyleDown,
              height: 60.0,
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(Icons.lock, color: Colors.black87),
                    hintText: 'Mot de passe',
                    hintStyle: kHintTextStyle),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              decoration: kBoxDecorationStyleDown,
              height: 60.0,
              child: TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(Icons.lock, color: Colors.black87),
                    hintText: 'Confirmez',
                    hintStyle: kHintTextStyle),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: (() {
                if (mailController.text.isEmpty ||
                    passwordController.text.isEmpty ||
                    confirmPasswordController.text.isEmpty ||
                    passwordController.text != confirmPasswordController.text) {
                  Get.snackbar("Erreur lors de l'inscription",
                      "Merci de compléter tous les champs ou vérifiez que les mots de passes sont pareils.",
                      backgroundColor: Colors.white);
                  return;
                }
                Authentication.signUpWithEmailAndPassword(
                    mailController.text, passwordController.text, context);
              }),
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(5.0),
                  padding: MaterialStateProperty.all(EdgeInsets.all(15.0)),
                  backgroundColor: MaterialStateProperty.all(Color(0xFF527DAA)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)))),
              child: Text(
                'INSCRIPTION !',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      });
}
