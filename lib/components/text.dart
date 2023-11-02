import 'package:flutter/material.dart';

class Jina extends StatefulWidget {
  final String text;
  final Color rangi;

  const Jina({
    super.key,
    required this.text,
    required this.rangi,
  });

  @override
  State<Jina> createState() => _JinaState();
}

class _JinaState extends State<Jina> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
        fontFamily: "Gilmer",
        fontSize: 14,
       fontWeight: FontWeight.w700,
        color: widget.rangi, // Set the text color here
      ),
    );
  }
}
