import 'package:flutter/material.dart';
import 'package:mavunohub/cards/my_tile.dart';
import 'package:showcaseview/showcaseview.dart';

class Explainer extends StatefulWidget {
  final String? title;
  final String? description;
  final Widget? target;
  final GlobalKey? keyValue;

  const Explainer({
    this.title,
    this.description,
    this.target,
    this.keyValue,
  });

  @override
  State<Explainer> createState() => _ExplainerState();
}

class _ExplainerState extends State<Explainer> {
  @override
  Widget build(BuildContext context) {
    return Showcase(
      title: widget.title!,
      overlayColor: Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
      key: widget.keyValue!,
      description: widget.description!,
      tooltipBackgroundColor: Theme.of(context).colorScheme.onError,
      titleTextStyle: TextStyle(
        fontFamily: 'Gilmer',
        fontSize: 14,
        color: Theme.of(context).colorScheme.tertiary,
        fontWeight: FontWeight.w700,
      ),
      descTextStyle: TextStyle(
        fontFamily: 'Gilmer',
        fontSize: 14,
        color: Theme.of(context).colorScheme.tertiary,
        fontWeight: FontWeight.w700,
      ),
      child: widget.target!,
    );
  }
}
