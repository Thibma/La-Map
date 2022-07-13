import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:la_map/models/google_places_model.dart';
import 'package:la_map/utils/constants.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../services/network.dart';

class AddLocalisationPage extends StatefulWidget {
  AddLocalisationPage({Key? key, required this.initialPosition})
      : super(key: key);

  final LatLng initialPosition;

  @override
  _AddLocalisationPage createState() => _AddLocalisationPage();
}

class _AddLocalisationPage extends State<AddLocalisationPage> {
  late LatLng initialPosition;
  late GoogleMapController mapController;

  final textController = TextEditingController();

  RxString changed = RxString("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Ajout d'une localisation",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onTap: (argument) {
              FocusManager.instance.primaryFocus?.unfocus();
              changed.value = "";
            },
            myLocationButtonEnabled: false,
            onMapCreated: _onMapCreated,
            initialCameraPosition: (CameraPosition(
              target: initialPosition,
              zoom: 11.0,
            )),
            onCameraMove: onCameraMove,
            onCameraIdle: () async {
              getMoveCamera();
            },
            rotateGesturesEnabled: false,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: kBoxDecorationStyleTranspa,
                  height: 50.0,
                  child: TextField(
                    controller: textController,
                    onChanged: onChanged,
                    onSubmitted: (result) {
                      changed.value = "";
                    },
                    //onSubmitted: onChanged,
                    keyboardType: TextInputType.streetAddress,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 15),
                        prefixIcon: Icon(Icons.search, color: primaryColor),
                        suffixIcon: IconButton(
                          onPressed: clearTextField,
                          icon: Icon(
                            Icons.clear,
                            color: primaryColor,
                          ),
                        ),
                        hintText: 'Localisation',
                        hintStyle: kHintTextStyle),
                  ),
                ),
              ),
              Obx(
                () => FutureBuilder(
                  future: Network()
                      .getAutocompletePlaces(changed.value, Uuid().v4()),
                  builder: (context,
                          AsyncSnapshot<List<Suggestion>?> snapshot) =>
                      changed.value == ''
                          ? Container()
                          : snapshot.hasData
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, left: 20, right: 20),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length > 5
                                        ? 5
                                        : snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration:
                                            BoxDecoration(color: Colors.white),
                                        child: ListTile(
                                          minLeadingWidth: 2,
                                          tileColor: Colors.black,
                                          title: Text(
                                            snapshot.data![index].description,
                                          ),
                                          onTap: () async {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            changed.value = "";
                                            final selecedPlace = await Network()
                                                .getDetailPlace(
                                                    snapshot
                                                        .data![index].placeId,
                                                    Uuid().v4());
                                            mapController.moveCamera(
                                                CameraUpdate.newLatLngZoom(
                                                    LatLng(
                                                        selecedPlace.latitude,
                                                        selecedPlace.longitude),
                                                    16));
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.location_on,
              size: 50,
              color: Colors.redAccent,
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.all(20.0),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (() => Get.back(result: initialPosition)),
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(5.0),
                  padding: MaterialStateProperty.all(EdgeInsets.all(15.0)),
                  backgroundColor: MaterialStateProperty.all(Color(0xFF527DAA)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)))),
              child: Text(
                'Ajouter cette localisation',
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
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  void onChanged(String result) {
    changed.value = result;
  }

  @override
  void initState() {
    initialPosition = widget.initialPosition;
    super.initState();
  }

  void onCameraMove(CameraPosition position) async {
    initialPosition = position.target;
  }

  void getMoveCamera() async {
    List<Placemark> placemark = await placemarkFromCoordinates(
        initialPosition.latitude, initialPosition.longitude,
        localeIdentifier: "fr_FR");
    textController.text = placemark[0].street! + " - " + placemark[0].locality!;
  }

  void clearTextField() {
    textController.clear();
    changed.value = "";
  }
}
