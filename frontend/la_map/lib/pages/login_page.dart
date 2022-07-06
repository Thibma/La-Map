import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:la_map/pages/home_page.dart';
import 'package:la_map/pages/signup_page.dart';
import 'package:la_map/pages/widgets/ok_dialog.dart';
import 'package:la_map/pages/widgets/main_button.dart';
import 'package:la_map/pages/widgets/signup_password.dart';
import 'package:la_map/pages/widgets/text_field_login.dart';
import 'package:la_map/services/authentication.dart';
import 'package:la_map/services/network.dart';
import 'package:la_map/utils/alerdialog_error.dart';
import 'package:la_map/utils/constants.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  Widget emailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 5.0,
        ),
        SizedBox(
            height: 60.0,
            child: TextFieldLogin(
              controller: emailTextController,
              icon: Icons.mail,
              hint: "Votre adresse mail",
            )),
      ],
    );
  }

  Widget passwordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Mot de passe',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 5.0,
        ),
        SizedBox(
            height: 60.0,
            child: TextFieldLogin(
              controller: passwordTextController,
              icon: Icons.lock,
              hint: "Votre mot de passe",
              obscureText: true,
            )),
      ],
    );
  }

  Widget connexionButton() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: MainElevatedButton(
          onPressed: signInButton,
          textButton: "Se connecter",
        ));
  }

  Widget googleConnexionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Image.asset(
          'assets/logos/google.png',
          width: 25,
          height: 25,
        ),
        onPressed: signInGoogle,
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(5.0),
            padding: MaterialStateProperty.all(EdgeInsets.all(15.0)),
            overlayColor: MaterialStateProperty.all(Colors.black12),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)))),
        label: Text(
          'Connexion avec Google',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget signupTextView() {
    return GestureDetector(
      onTap: (() => Get.dialog(SignUpDialog())),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Pas de compte ? ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: "Inscris-toi",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget home() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF56CCF2),
                    Color(0xFF2F80ED),
                  ],
                  stops: [0.4, 0.9],
                ),
              ),
            ),
            SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 80.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('La MAP !',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      height: 30.0,
                    ),
                    emailTextField(),
                    SizedBox(
                      height: 30.0,
                    ),
                    passwordTextField(),
                    connexionButton(),
                    googleConnexionButton(),
                    SizedBox(
                      height: 30.0,
                    ),
                    signupTextView(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Authentication.initializeFirebase(context: context),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            );
          default:
            if (snapshot.hasError) {
              return AlertDialog(
                title: Text('Erreur de connexion'),
                actions: [
                  ElevatedButton(
                    onPressed: () => {exit(0)},
                    child: Text('Fermer'),
                  )
                ],
              );
            } else {
              return home();
            }
        }
      },
    );
  }

  void signInButton() async {
    try {
      if (emailTextController.text.isEmpty ||
          passwordTextController.text.isEmpty) {
        throw ("Merci de remplir tous les champs");
      }

      Get.defaultDialog(
        title: "Connexion",
        content: CircularProgressIndicator(
          color: primaryColor,
        ),
        barrierDismissible: false,
      );

      final firebaseUser = await Authentication.signInWithEmailPassword(
          emailTextController.text, passwordTextController.text);
      login(firebaseUser.uid);
    } catch (e) {
      Get.back();
      Get.dialog(OkDialog(
          titleError: "Erreur lors de la connexion",
          contentError: e.toString()));
    }
  }

  void signInGoogle() async {
    try {
      Get.defaultDialog(
        title: "Connexion",
        content: CircularProgressIndicator(
          color: primaryColor,
        ),
        barrierDismissible: false,
      );

      final firebaseUser =
          await Authentication.signInWithGogle(context: context);
      login(firebaseUser.uid);
    } catch (e) {
      Get.back();
      if (e == "Annulé") {
        return;
      }
    }
  }

  void login(String firebaseId) async {
    try {
      final apiUser = await Network().login(firebaseId);
      Get.back();
      Get.offAll(HomePage(
        user: apiUser,
      ));
    } catch (e) {
      if (e != firebaseId) {
        Get.back();
        Get.dialog(OkDialog(
            titleError: "Erreur lors de la connexion",
            contentError: "Impossible de se connecter au serveur."));
        return;
      }
      Get.back();
      Get.to(SignUpPage(uid: firebaseId));
    }
  }
}
