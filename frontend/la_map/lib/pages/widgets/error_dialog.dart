import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:la_map/utils/constants.dart';

class ErrorDialog extends StatelessWidget {
  ErrorDialog({
    Key? key,
    required this.titleError,
    required this.contentError,
  }) : super(key: key);

  final String titleError;
  final String contentError;

  final Widget cancelButton = TextButton(
    child: Text(
      "OK",
      style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
    ),
    onPressed: () {
      Get.back(result: false);
    },
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        titleError,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            contentError,
            style: TextStyle(color: Colors.black),
          )
        ],
      ),
      actions: [cancelButton],
    );
  }
}
