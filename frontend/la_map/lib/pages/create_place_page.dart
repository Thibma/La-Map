import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:la_map/pages/add_localisation_page.dart';
import 'package:la_map/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class CreatePlacePage extends StatefulWidget {
  CreatePlacePage({Key? key, required LatLng initialPosition})
      : _initialPosition = initialPosition,
        super(key: key);

  final LatLng _initialPosition;

  @override
  _CreatePlaceState createState() => _CreatePlaceState();
}

class _CreatePlaceState extends State<CreatePlacePage> {
  final nameTextController = TextEditingController();
  final withWhoTextController = TextEditingController();
  final noteTextController = TextEditingController();

  late LatLng initialPosition;

  final selectedPosition = Rxn<LatLng>();

  final _image = Rxn<File>();
  final _picker = ImagePicker();

  DateTime selectedDate = DateTime.now();

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

  @override
  void initState() {
    initialPosition = widget._initialPosition;
    super.initState();
  }
}
