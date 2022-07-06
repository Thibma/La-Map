import 'package:flutter/material.dart';
import 'package:la_map/pages/widgets/ok_dialog.dart';
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Dialog(
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
                controller: passwordController,
                obscureText: true,
              ),
              SizedBox(
                height: 20,
              ),
              TextFieldLogin(
                hint: "Confirmez le mot de passe",
                icon: Icons.lock_person,
                controller: confirmPasswordController,
                obscureText: true,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: MainElevatedButton(
                  textButton: "S'inscrire",
                  onPressed: (() async {
                    try {
                      Get.defaultDialog(
                        title: "Connexion",
                        content: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                        barrierDismissible: false,
                      );
                      if (mailController.text.isEmpty ||
                          passwordController.text.isEmpty ||
                          confirmPasswordController.text.isEmpty) {
                        throw ("Merci de remplir tous les champs");
                      } else if (passwordController.text !=
                          confirmPasswordController.text) {
                        throw ("Les mots de passe ne sont pas les mêmes");
                      }

                      await Authentication.signUpWithEmailAndPassword(
                          mailController.text,
                          passwordController.text,
                          context);
                      Get.back();
                      Get.back();
                      Get.dialog(OkDialog(
                          titleError: "Inscription réussie",
                          contentError:
                              "Vous pouvez désormais vous connecter avec vos identifiants"));
                    } catch (e) {
                      Get.back();
                      Get.dialog(OkDialog(
                          titleError: "Erreur lors de l'inscription",
                          contentError: e.toString()));
                    }
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
