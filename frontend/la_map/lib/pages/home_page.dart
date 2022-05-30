import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:la_map/models/user_model.dart';
import 'package:la_map/pages/create_place_page.dart';
import 'package:location/location.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User user;
  late GoogleMapController mapController;
  Location location = Location();

  late LocationData _locationData;

  final LatLng initialPosition = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "La Map - " + user.pseudo,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: FutureBuilder(
          future: loadImage(),
          builder: (BuildContext context, AsyncSnapshot<String> image) {
            if (image.hasData) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.network(
                  image.data.toString(),
                ),
              );
            } else {
              return CircularProgressIndicator(
                color: Colors.blue,
              );
            }
          },
        ),
        backgroundColor: Color(0xFF527DAA),
        actions: [
          IconButton(
              onPressed: () => {print("test")}, icon: const Icon(Icons.person))
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            initialCameraPosition:
                CameraPosition(target: initialPosition, zoom: 11.0),
            zoomControlsEnabled: false,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () => Get.to(CreatePlacePage(
                  initialPosition:
                      LatLng(_locationData.latitude!, _locationData.longitude!),
                )),
                backgroundColor: Color(0xFF527DAA),
                child: Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> loadImage() async {
    Reference ref = FirebaseStorage.instance.ref().child(user.idImage);
    var url = await ref.getDownloadURL();
    return url;
  }

  @override
  void initState() {
    user = widget._user;
    getLocation();
    super.initState();
  }

  void getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    _locationData = await location.getLocation();
    mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_locationData.latitude!, _locationData.longitude!),
        zoom: 16.0)));
  }
}
