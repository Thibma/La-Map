import 'package:flutter/material.dart';

const kLabelStyle =
    TextStyle(color: Colors.black45, fontWeight: FontWeight.bold);

final kBoxDecorationStyle = BoxDecoration(
  color: const Color.fromARGB(188, 62, 162, 144),
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
  color: Color.fromARGB(187, 62, 137, 162),
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
