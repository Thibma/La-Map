import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:la_map/utils/constants.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class AddLocalisationPage extends StatefulWidget {
  AddLocalisationPage({Key? key, required LatLng initialPosition})
      : _initialPosition = initialPosition,
        super(key: key);

  final LatLng _initialPosition;

  @override
  _AddLocalisationPage createState() => _AddLocalisationPage();
}

class _AddLocalisationPage extends State<AddLocalisationPage> {
  late LatLng initialPosition;
  late GoogleMapController mapController;

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ajout d'une localisation",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF527DAA),
      ),
      body: Stack(
        children: [
          GoogleMap(
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              alignment: Alignment.centerLeft,
              decoration: kBoxDecorationStyleTranspa,
              height: 50.0,
              child: TextField(
                controller: textController,
                keyboardType: TextInputType.streetAddress,
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search,
                        color: Color.fromARGB(221, 255, 255, 255)),
                    hintText: 'Localisation',
                    hintStyle: kHintTextStyle),
              ),
            ),
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

  @override
  void initState() {
    initialPosition = widget._initialPosition;
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
}
