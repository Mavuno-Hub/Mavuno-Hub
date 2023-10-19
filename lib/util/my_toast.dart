import 'package:flutter/material.dart';

class CustomToast extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;

  const CustomToast({super.key, 
    required this.message,
    this.backgroundColor = Colors.black87,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: textColor,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
