import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String? message) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message ?? 'Error occured'),
    ),
  );
}
