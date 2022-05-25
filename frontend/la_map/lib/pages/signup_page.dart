import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:la_map/pages/home_page.dart';
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

  Future<void> _openImagePicker() async {
    await _picker.pickImage(source: ImageSource.gallery).then((photo) async {
      await ImageCropper().cropImage(
          sourcePath: photo!.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square
          ]).then((croppedPhoto) {
        _image.value = File(croppedPhoto!.path);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
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
                    children: [
                      Text(
                        "Inscription !",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Choisissez une photo de profil et un pseudo pour finaliser l'inscription.",
                        style: kLabelStyle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Obx(
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
                      SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (() => _openImagePicker()),
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(5.0),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.all(15.0)),
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 60, 97, 137)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)))),
                          child: Text(
                            'Ajouter une photo',
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: kBoxDecorationStyleDown,
                        height: 60.0,
                        child: TextField(
                          controller: textController,
                          keyboardType: TextInputType.name,
                          style: TextStyle(color: Colors.black38),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 14.0),
                              prefixIcon:
                                  Icon(Icons.person, color: Colors.black87),
                              hintText: 'Pseudo',
                              hintStyle: kHintTextStyle),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 30.0,
                  ),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (() => signUp()),
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(5.0),
                        padding:
                            MaterialStateProperty.all(EdgeInsets.all(15.0)),
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFF527DAA)),
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
                ),
              ),
            ],
          ),
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
          .then((value) {
        Navigator.pop(context);
        Get.offAll(HomePage());
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
