import 'dart:io';

import 'package:flutter/material.dart';
import 'package:la_map/pages/home_page.dart';
import 'package:la_map/pages/widgets/main_button.dart';
import 'package:la_map/pages/widgets/ok_dialog.dart';
import 'package:la_map/pages/widgets/text_field_login.dart';
import 'package:la_map/services/network.dart';
import 'package:la_map/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/user_model.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key, required this.firebaseId}) : super(key: key);

  final String firebaseId;

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignUpPage> {
  late String firebaseId;

  final _image = Rxn<File>();
  final _picker = ImagePicker();
  final textController = TextEditingController();

  @override
  void initState() {
    firebaseId = widget.firebaseId;

    super.initState();
  }

  Future<void> openImagePicker() async {
    try {
      final file = await _picker.pickImage(source: ImageSource.gallery);
      final croppedFile = await ImageCropper().cropImage(
          sourcePath: file!.path,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          uiSettings: [
            IOSUiSettings(
                doneButtonTitle: "Confirmer", cancelButtonTitle: "Annuler")
          ]);
      _image.value = File(croppedFile!.path);
    } catch (e) {
      // Annulé
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                  vertical: 60.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "C'est presque fini !",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Choisissez une photo de profil et un pseudo pour finaliser l'inscription.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Obx(
                        () => _image.value != null
                            ? Image.file(
                                _image.value!,
                                width: 250.0,
                                height: 250.0,
                              )
                            : Image.asset(
                                'assets/profile_picture.png',
                                width: 250.0,
                                height: 250.0,
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: MainElevatedButton(
                        onPressed: openImagePicker,
                        textButton: "Ajouter une photo",
                        isMainButton: false,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFieldLogin(
                        hint: "Votre pseudo",
                        icon: Icons.person,
                        controller: textController),
                    SizedBox(
                      height: 60,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: MainElevatedButton(
                        onPressed: signUp,
                        textButton: "Inscription !",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signUp() async {
    try {
      Get.defaultDialog(
        title: "Inscription...",
        content: CircularProgressIndicator(
          color: Colors.blue,
        ),
        barrierDismissible: false,
      );

      if (textController.text.isEmpty || _image.value == null) {
        throw ("Merci de remplir tous les champs et de sélectionner une image.");
      }

      final profileStorage =
          FirebaseStorage.instance.ref().child("profilePictures");
      final reference = profileStorage.child(firebaseId);
      await reference.putFile(_image.value!);
      ApiUser user = await Network()
          .signUp(textController.text, firebaseId, reference.fullPath);
      Get.back();
      Get.offAll(HomePage(user: user));
    } catch (e) {
      Get.back();
      Get.dialog(OkDialog(
          titleError: "Erreur lors de l'inscription",
          contentError: e.toString()));
    }
  }
}
