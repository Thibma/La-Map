import 'package:flutter/material.dart';

Color primaryColor = Color(0xFf1a237e);
Color lightColor = Color(0x9ffc4dcc);
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
  color: Color.fromARGB(168, 93, 93, 93),
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
