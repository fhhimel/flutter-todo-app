import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, {
  required String message
}) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.red,);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}