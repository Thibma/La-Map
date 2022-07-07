import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:la_map/models/place_model.dart';
import 'package:la_map/models/user_model.dart';
import 'package:la_map/pages/create_place_page.dart';
import 'package:la_map/pages/widgets/main_button.dart';
import 'package:la_map/utils/constants.dart';
import 'package:location/location.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.user}) : super(key: key);

  final ApiUser user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ApiUser user;
  late GoogleMapController mapController;
  Location location = Location();

  late LocationData _locationData;

  final LatLng initialPosition = const LatLng(45.521563, -122.677433);

  final lastPlaceAdd = Rxn<Place>();

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getLocation(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Chargement..."),
                    ],
                  ),
                ),
              );
            case ConnectionState.done:
              if (snapshot.data != null) {
                return mapBuild(snapshot.data as LatLng);
              } else {
                return errorPage();
              }
            default:
              return errorPage();
          }
        });
  }

  Widget mapBuild(LatLng latLng) {
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
                padding: const EdgeInsets.only(left: 10),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    image.data.toString(),
                  ),
                ),
              );
            } else {
              return CircularProgressIndicator(
                color: Colors.blue,
              );
            }
          },
        ),
        backgroundColor: primaryColor,
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
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(target: latLng, zoom: 15.0),
            zoomControlsEnabled: false,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () async {
                  lastPlaceAdd.value = await Get.to(() => CreatePlacePage(
                        initialPosition: LatLng(
                            _locationData.latitude!, _locationData.longitude!),
                        user: user,
                      ));
                  if (lastPlaceAdd.value != null) {
                    Get.snackbar("Lieu ajouté avec succès",
                        "Le lieu a bien été ajouté à la base de donnée.",
                        backgroundColor: Colors.white);
                  }
                },
                backgroundColor: primaryColor,
                child: Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget errorPage() {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(40),
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Erreur lors du chargement de la carte. Vérifiez que vous avez bien acceptez toutes les permissions.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: MainElevatedButton(
                  onPressed: () async {
                    openAppSettings();
                  },
                  textButton: "Ouvrir les paramètres",
                  isMainButton: false,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: MainElevatedButton(
                  onPressed: () async {
                    setState(() {});
                  },
                  textButton: "Réessayer",
                ),
              )
            ],
          ),
        ),
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
    user = widget.user;
    super.initState();
  }

  Future<LatLng?> getLocation() async {
    if (await Permission.location.serviceStatus.isDisabled) {
      return null;
    }
    var status = await Permission.location.request();
    if (status.isPermanentlyDenied) {
      return null;
    }

    _locationData = await location.getLocation();

    return LatLng(_locationData.latitude!, _locationData.longitude!);
  }
}
