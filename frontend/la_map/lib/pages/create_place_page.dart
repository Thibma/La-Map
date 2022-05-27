import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:la_map/utils/constants.dart';

class CreatePlacePage extends StatefulWidget {
  CreatePlacePage({Key? key}) : super(key: key);

  @override
  _CreatePlaceState createState() => _CreatePlaceState();
}

class _CreatePlaceState extends State<CreatePlacePage> {
  final nameTextController = TextEditingController();
  final withWhoTextController = TextEditingController();
  final noteTextController = TextEditingController();

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
                              onPressed: (() => print("")),
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
                                'Ajouter une localisation',
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
}
