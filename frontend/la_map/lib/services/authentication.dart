import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

class Authentication {
  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // SignIn API
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage))
      print(user);
    }

    return firebaseApp;
  }

  static Future<User> signInWithGogle({required BuildContext context}) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        throw ("Annulé");
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        if (userCredential.user == null) {
          throw ("Une erreur de connexion avec le serveur a eu lieu");
        }
        return userCredential.user!;
      } on FirebaseAuthException catch (e) {
        if (e.code == "account-exists-with-different-credential") {
          throw ("Ce compte existe déjà avec un autre système d'identification.");
        } else if (e.code == "user-disabled") {
          throw ("L'utilisateur a été désactivé.");
        } else {
          throw ("Une erreur de connexion a eu lieu.");
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> signUpWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw ("Mot de passe trop faible");
      } else if (e.code == 'email-already-in-use') {
        throw ("Un compte existe déjà avec cette adresse mail.");
      } else if (e.code == 'invalid-email') {
        throw ("Votre adresse mail n'est pas valide");
      } else {
        throw ("Une erreur de connexion a eu lieu lors de l'inscription");
      }
    }
  }

  static Future<User> signInWithEmailPassword(
      String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user!;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        throw ("L'adresse mail n'est pas valide.");
      } else if (e.code == "user-disabled") {
        throw ("L'utilisateur a été désactivé.");
      } else if (e.code == "user-not-found") {
        throw ("Le compte lié a cette adresse mail n'existe pas.");
      } else if (e.code == "wrong-password") {
        throw ("Le mot de passe est incorrect.");
      } else {
        throw ("Une erreur de connexion a eu lieu.");
      }
    }
  }
}
