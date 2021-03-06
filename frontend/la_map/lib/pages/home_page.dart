import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:la_map/models/place_model.dart';
import 'package:la_map/models/user_model.dart';
import 'package:la_map/pages/create_place_page.dart';
import 'package:la_map/pages/widgets/main_button.dart';
import 'package:la_map/pages/widgets/popover.dart';
import 'package:la_map/services/network.dart';
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
  List<Marker> userPlaces = [];

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
          FutureBuilder(
            future: Network().getUserPlaces(user.id),
            builder: (context, data) {
              if (data.connectionState == ConnectionState.waiting) {
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
              } else {
                if (data.hasData) {
                  for (Place place in data.data as List<Place>) {
                    userPlaces.add(Marker(
                        markerId: MarkerId(place.id),
                        position: LatLng(place.coordinates.latitude,
                            place.coordinates.longitude),
                        onTap: () => onMarkerTap(place),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueGreen)));
                  }
                }
                return GoogleMap(
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  initialCameraPosition:
                      CameraPosition(target: latLng, zoom: 15.0),
                  zoomControlsEnabled: false,
                  markers: Set<Marker>.of(userPlaces),
                );
              }
            },
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
                    Get.snackbar("Lieu ajout?? avec succ??s",
                        "Le lieu a bien ??t?? ajout?? ?? la base de donn??e.",
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

  void onMarkerTap(Place place) {
    showModalBottomSheet(
        barrierColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Popover(
              child: Container(
            height: 200,
            child: Column(children: [
              Text(
                place.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              )
            ]),
          ));
        });
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
                "Erreur lors du chargement de la carte. V??rifiez que vous avez bien acceptez toutes les permissions.",
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
                  textButton: "Ouvrir les param??tres",
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
                  textButton: "R??essayer",
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
