import 'package:flutter/material.dart';

showMySnackBar(
    {required BuildContext context,
    required String text,
    bool isError = true}) {
  SnackBar snackBar = SnackBar(
    content: Text(text),
    backgroundColor: (isError) ? Colors.red : Colors.green,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
    duration: const Duration(seconds: 4),
    showCloseIcon: true,
    closeIconColor: Colors.white,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
