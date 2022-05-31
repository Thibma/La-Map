import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:la_map/models/user_model.dart';
import 'package:la_map/pages/add_localisation_page.dart';
import 'package:la_map/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:la_map/services/network.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreatePlacePage extends StatefulWidget {
  CreatePlacePage(
      {Key? key, required LatLng initialPosition, required User user})
      : _initialPosition = initialPosition,
        _user = user,
        super(key: key);

  final LatLng _initialPosition;
  final User _user;

  @override
  _CreatePlaceState createState() => _CreatePlaceState();
}

class _CreatePlaceState extends State<CreatePlacePage> {
  final nameTextController = TextEditingController();
  final withWhoTextController = TextEditingController();
  final noteTextController = TextEditingController();

  late LatLng initialPosition;
  late User user;

  final selectedPosition = Rxn<LatLng>();

  final _image = Rxn<File>();
  final _picker = ImagePicker();

  final selectedDate = Rx<DateTime>(DateTime.now());

  String selectedDropDownValue = "visible";

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Visible"), value: "visible"),
      DropdownMenuItem(child: Text("Invisible"), value: "invisible"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Création d'un Lieu",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF527DAA),
      ),
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
                    vertical: 20.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nom du lieu *',
                            style: kLabelStyle,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            decoration: kBoxDecorationStyleLight,
                            height: 60.0,
                            child: TextField(
                              controller: nameTextController,
                              keyboardType: TextInputType.name,
                              style: TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15.0),
                                  hintText: 'Nom',
                                  hintStyle: kHintTextStyle),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Avec qui ?',
                            style: kLabelStyle,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            decoration: kBoxDecorationStyleLight,
                            height: 60.0,
                            child: TextField(
                              controller: withWhoTextController,
                              keyboardType: TextInputType.name,
                              style: TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15.0),
                                  hintText: 'Avec qui ?',
                                  hintStyle: kHintTextStyle),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notes',
                            style: kLabelStyle,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            decoration: kBoxDecorationStyleLight,
                            height: 120.0,
                            child: TextField(
                              controller: noteTextController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              style: TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15.0),
                                  hintText: 'Raconte tout !',
                                  hintStyle: kHintTextStyle),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: (() async {
                                selectedPosition.value = await Get.to(
                                    AddLocalisationPage(
                                        initialPosition: initialPosition));
                                print(selectedPosition);
                              }),
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(5.0),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.all(15.0)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFF527DAA)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0)))),
                              child: Obx(
                                () => Text(
                                  selectedPosition.value == null
                                      ? 'Ajouter une localisation *'
                                      : "Localisation ajoutée",
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
                                      Color(0xFF527DAA)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0)))),
                              child: Text(
                                "Ajouter une photo",
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
                            height: 20.0,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Obx(
                                () => _image.value == null
                                    ? Image.asset(
                                        'assets/profile_picture.png',
                                        width: 100,
                                        height: 100,
                                      )
                                    : Image.file(
                                        _image.value!,
                                        width: 100.0,
                                        height: 100.0,
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: (() => _selectDate(context)),
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(5.0),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.all(15.0)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFF527DAA)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0)))),
                              child: Obx(
                                () => Text(
                                  "Date : " +
                                      selectedDate.value.day.toString() +
                                      "/" +
                                      selectedDate.value.month.toString() +
                                      "/" +
                                      selectedDate.value.year.toString(),
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
                          SizedBox(
                            height: 20.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Visibilité *',
                                style: kLabelStyle,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                alignment: Alignment.center,
                                decoration: kBoxDecorationStyleLight,
                                child: DropdownButtonFormField<String>(
                                  value: selectedDropDownValue,
                                  items: dropdownItems,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedDropDownValue = value!;
                                    });
                                  },
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 15.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: (() => createPlace()),
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(5.0),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.all(15.0)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 33, 112, 197)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0)))),
                              child: Text(
                                "Créer le Lieu",
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(1999, 21),
      lastDate: selectedDate.value,
      locale: Locale('fr', 'FR'),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  void createPlace() async {
    if (nameTextController.text.isEmpty || selectedPosition.value == null) {
      Get.snackbar("Erreur lors de la création du lieu",
          "Merci de remplir tous les champs obligatoires.",
          backgroundColor: Colors.white);
      return;
    }

    Get.defaultDialog(
      title: "Création du lieu...",
      content: CircularProgressIndicator(
        color: Colors.blue,
      ),
      barrierDismissible: false,
    );

    final profileStorage = FirebaseStorage.instance.ref().child("place");
    final userStorage = profileStorage.child(user.idFirebase);
    final reference = userStorage.child(nameTextController.text +
        selectedPosition.value!.latitude.toString() +
        selectedPosition.value!.longitude.toString());
    String imagePath = "";
    if (_image.value != null) {
      reference.putFile(_image.value!);
      imagePath = reference.fullPath;
    }

    await Network()
        .createPlace(
            nameTextController.text,
            user.id,
            withWhoTextController.text,
            imagePath,
            selectedPosition.value!,
            selectedDate.value,
            selectedDropDownValue,
            noteTextController.text)
        .then((place) {
      Navigator.pop(context);
      Get.back(result: place);
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      Get.defaultDialog(
        title: "Erreur de connexion",
        content: Text("Il y a eu un problème lors de la création d'un lieu"),
        textConfirm: "OK",
      );
    });
  }

  @override
  void initState() {
    initialPosition = widget._initialPosition;
    user = widget._user;
    super.initState();
  }
}
