import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:la_map/pages/home_page.dart';
import 'package:la_map/pages/widgets/main_button.dart';
import 'package:la_map/pages/widgets/text_field_login.dart';
import 'package:la_map/services/network.dart';
import 'package:la_map/utils/alerdialog_error.dart';
import 'package:la_map/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key, required String uid})
      : _uid = uid,
        super(key: key);

  final String _uid;

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignUpPage> {
  late String _uid;

  final _image = Rxn<File>();
  final _picker = ImagePicker();
  final textController = TextEditingController();

  Future<void> openImagePicker() async {
    try {
      final file = await _picker.pickImage(source: ImageSource.gallery);
      final croppedFile = await ImageCropper().cropImage(
          sourcePath: file!.path,
          aspectRatioPresets: [CropAspectRatioPreset.square]);
      _image.value = File(croppedFile!.path);
    } catch (e) {
      //
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

  void signUp() {
    if (textController.text.isEmpty || _image.value == null) {
      errorDialog(context, "Merci de remplir tous les champs.");
      return;
    }

    Get.defaultDialog(
      title: "Connexion",
      content: CircularProgressIndicator(
        color: Colors.blue,
      ),
      barrierDismissible: false,
    );

    final profileStorage =
        FirebaseStorage.instance.ref().child("profilePictures");
    final reference = profileStorage.child(_uid);
    reference.putFile(_image.value!).then((p0) {
      Network()
          .signUp(textController.text, _uid, reference.fullPath)
          .then((user) {
        Navigator.pop(context);
        Get.offAll(HomePage(user: user));
      }).onError((error, stackTrace) {
        Navigator.pop(context);
        Get.defaultDialog(
          title: "Erreur de connexion",
          content: Text("Il y a eu un problème lors de l'inscription."),
          textConfirm: "OK",
        );
      });
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _uid = widget._uid;

    super.initState();
  }
}
