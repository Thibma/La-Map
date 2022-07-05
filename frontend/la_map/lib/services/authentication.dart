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

  static Future<User?> signInWithGogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        print(e);
      }
    }
    return user;
  }

  static void signUpWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Navigator.pop(context);
        Get.snackbar(
            "Inscription complétée", "Vous pouvez désormais vous connecter.",
            backgroundColor: Colors.white);
        return;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar("Erreur lors de l'inscription", "Mot de passe trop faible",
            backgroundColor: Colors.white);
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar("Erreur lors de l'inscription",
            "Un compte existe déjà avec cette adresse mail.",
            backgroundColor: Colors.white);
      } else {
        Get.snackbar("Erreur lors de l'inscription",
            "Une erreur a eu lieu lors de l'inscripton.",
            backgroundColor: Colors.white);
      }
    }
  }

  static Future<User?> signInWithEmailPassword(
      String email, String password) async {
    User? user;
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    } catch (e) {
      rethrow;
    }
    return user;
  }
}
