import 'package:flutter/material.dart';

class SnackBarHelper {
  final BuildContext context;

  SnackBarHelper(this.context);

  void showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Gilmer',
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 16,
          ),
        ),
        backgroundColor: isError
            ? Theme.of(context).colorScheme.errorContainer
            : Theme.of(context).colorScheme.surface,
      ),
    );
  }


}