import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        content: Text(
          content,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Gilmer',
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 16,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.errorContainer),
  );
}
