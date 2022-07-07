import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:la_map/models/user_model.dart';
import 'package:la_map/pages/add_localisation_page.dart';
import 'package:la_map/pages/widgets/main_button.dart';
import 'package:la_map/pages/widgets/ok_dialog.dart';
import 'package:la_map/pages/widgets/text_field.dart';
import 'package:la_map/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:la_map/services/network.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreatePlacePage extends StatefulWidget {
  CreatePlacePage({Key? key, required this.initialPosition, required this.user})
      : super(key: key);

  final LatLng initialPosition;
  final ApiUser user;

  @override
  _CreatePlaceState createState() => _CreatePlaceState();
}

class _CreatePlaceState extends State<CreatePlacePage> {
  final nameTextController = TextEditingController();
  final withWhoTextController = TextEditingController();
  final noteTextController = TextEditingController();

  late LatLng initialPosition;
  late ApiUser user;

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

  void addLocation() async {
    selectedPosition.value = await Get.to(
        () => AddLocalisationPage(initialPosition: initialPosition));
    print(selectedPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Création d'un Lieu",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
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
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          SizedBox(
                            height: 60.0,
                            child: TextFieldWidget(
                                controller: nameTextController, hint: "Nom"),
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
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          SizedBox(
                            height: 60.0,
                            child: TextFieldWidget(
                              controller: withWhoTextController,
                              hint: "Avec qui ?",
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
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            constraints: BoxConstraints(maxHeight: 200),
                            child: TextFieldMultiline(
                              controller: noteTextController,
                              hint: "Raconte tout !",
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Obx(
                              () => selectedPosition.value == null
                                  ? MainElevatedButton(
                                      onPressed: addLocation,
                                      isMainButton: false,
                                      textButton: 'Ajouter une localisation *')
                                  : MainElevatedButton(
                                      onPressed: addLocation,
                                      isMainButton: false,
                                      textButton: 'Localisation ajoutée'),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: MainElevatedButton(
                              onPressed: openImagePicker,
                              isMainButton: false,
                              textButton: "Ajouter une photo",
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
                            child: Obx(
                              () => MainElevatedButton(
                                onPressed: () => selectDate(context),
                                isMainButton: false,
                                textButton: "Date : " +
                                    selectedDate.value.day.toString() +
                                    "/" +
                                    selectedDate.value.month.toString() +
                                    "/" +
                                    selectedDate.value.year.toString(),
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
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: DropdownButtonFormField(
                                  value: selectedDropDownValue,
                                  items: dropdownItems,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedDropDownValue = value as String;
                                    });
                                  },
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    hintText: "Visibilité *",
                                    filled: true,
                                    labelStyle: const TextStyle(fontSize: 12),
                                    fillColor: Colors.black12,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
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
                            child: MainElevatedButton(
                              onPressed: (() => createPlace()),
                              textButton: "Créer le lieu",
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

  Future<void> selectDate(BuildContext context) async {
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
    try {
      Get.defaultDialog(
        title: "Création du lieu...",
        content: CircularProgressIndicator(
          color: Colors.blue,
        ),
        barrierDismissible: false,
      );

      if (nameTextController.text.isEmpty || selectedPosition.value == null) {
        throw ("Merci de remplir tous les champs obligatoires.");
      }

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

      final place = await Network().createPlace(
          nameTextController.text,
          user.id,
          withWhoTextController.text,
          imagePath,
          selectedPosition.value!,
          selectedDate.value,
          selectedDropDownValue,
          noteTextController.text);

      Get.back(result: place);
    } catch (e) {
      Get.back();
      Get.dialog(OkDialog(
          titleError: "Erreur lors de la création du lieu",
          contentError: e.toString()));
    }
  }

  @override
  void initState() {
    initialPosition = widget.initialPosition;
    user = widget.user;
    super.initState();
  }
}
