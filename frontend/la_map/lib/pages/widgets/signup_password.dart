import 'package:flutter/material.dart';
import 'package:la_map/pages/widgets/main_button.dart';
import 'package:la_map/pages/widgets/text_field_login.dart';
import 'package:la_map/utils/constants.dart';
import 'package:get/get.dart';
import 'package:la_map/services/authentication.dart';

class SignUpDialog extends StatelessWidget {
  SignUpDialog({Key? key}) : super(key: key);

  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                "Inscription",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFieldLogin(
              controller: mailController,
              icon: Icons.mail,
              hint: "Votre adresse mail",
            ),
            SizedBox(
              height: 20,
            ),
            TextFieldLogin(
                hint: "Votre mot de passe",
                icon: Icons.lock,
                controller: passwordController),
            SizedBox(
              height: 20,
            ),
            TextFieldLogin(
                hint: "Confirmez le mot de passe",
                icon: Icons.lock_person,
                controller: confirmPasswordController),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              child: MainElevatedButton(
                textButton: "S'inscrire",
                onPressed: (() {
                  if (mailController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      confirmPasswordController.text.isEmpty ||
                      passwordController.text !=
                          confirmPasswordController.text) {
                    Get.snackbar("Erreur lors de l'inscription",
                        "Merci de compléter tous les champs ou vérifiez que les mots de passes sont pareils.",
                        backgroundColor: Colors.white);
                    return;
                  }
                  Authentication.signUpWithEmailAndPassword(
                      mailController.text, passwordController.text, context);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
