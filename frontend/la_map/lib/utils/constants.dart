import 'package:flutter/material.dart';

Color primaryColor = Color(0xFf1a237e);
Color lightColor = Color.fromARGB(159, 211, 77, 252);
Color darkColor = Color(0xff38006b);

const kLabelStyle =
    TextStyle(color: Colors.black45, fontWeight: FontWeight.bold);

final kBoxDecorationStyle = BoxDecoration(
  color: Color.fromARGB(79, 138, 138, 138),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final kBoxDecorationStyleTranspa = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final kBoxDecorationStyleDown = BoxDecoration(
  color: Color.fromARGB(186, 170, 170, 170),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final kBoxDecorationStyleLight = BoxDecoration(
  color: Color(0xFF527DAA),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

const kHintTextStyle = TextStyle(
  color: Colors.black38,
);
