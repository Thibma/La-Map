import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:la_map/models/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User user;
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
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
        //Image.network(url.toString()),
        backgroundColor: Color(0xFF527DAA),
        actions: [
          IconButton(
              onPressed: () => {print("test")}, icon: const Icon(Icons.person))
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
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
    super.initState();
  }
}
