import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:la_map/pages/login_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
      ),
      title: 'Login',
      home: Scaffold(
        body: LoginPage(),
      ),
    );
  }
}
