import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:la_map/pages/signup_page.dart';
import 'package:la_map/services/authentication.dart';

import 'dart:io';

import 'package:la_map/services/network.dart';
import 'package:la_map/utils/alerdialog_error.dart';
import 'package:la_map/utils/constants.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Widget _buildEmailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
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
      ],
    );
  }

  Widget _buildPasswordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Mot de passe',
          style: kLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(Icons.lock, color: Colors.black87),
                hintText: 'Mot de passe',
                hintStyle: kHintTextStyle),
          ),
        ),
      ],
    );
  }

  Widget _buildConnexionButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (() => print('test')),
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(5.0),
            padding: MaterialStateProperty.all(EdgeInsets.all(15.0)),
            backgroundColor: MaterialStateProperty.all(Color(0xFF527DAA)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)))),
        child: Text(
          'CONNEXION',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleConnexionButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0),
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Image.asset(
          'assets/logos/google.png',
          width: 30,
          height: 30,
        ),
        onPressed: (() async {
          await Authentication.signInWithGogle(context: context)
              .then((user) => Network()
                  .login(user!.uid)
                  .then((user) => print(user.pseudo))
                  .onError((error, stackTrace) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SignUpPage(uid: user.uid)))))
              .onError((error, stackTrace) =>
                  errorDialog(context, error.toString()));
        }),
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

  Widget _buildSignupTextView() {
    return GestureDetector(
      onTap: (() => print('signup')),
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
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF74EBD5),
                      Color(0xFFACB6E5),
                    ],
                    stops: [0.3, 0.9],
                  ),
                ),
              ),
              SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 80.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'La MAP !',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildEmailTextField(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildPasswordTextField(),
                      _buildConnexionButton(),
                      _buildGoogleConnexionButton(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildSignupTextView(),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
}
