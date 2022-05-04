import 'package:flutter/material.dart';

const kLabelStyle = TextStyle(
    color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'OpenSans');

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

const kHintTextStyle = TextStyle(
  color: Colors.black38,
  fontFamily: 'OpenSans',
);