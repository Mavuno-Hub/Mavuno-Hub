import 'package:flutter/material.dart';
import 'package:mavunohub/styles/pallete.dart';

class FormButton extends StatelessWidget {
  final String? text;
  final VoidCallback? action;

  const   FormButton( {super.key, 
    this.text,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0).add(const EdgeInsets.symmetric(vertical: 7)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 260.0,
              maxWidth: 304.0,
            ),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.tertiary,
              ),
              child: Center(
                child: Text(
                  text ?? '',
                  style: const TextStyle(
                    fontFamily: 'Gilmer',
                    fontSize: 18,
                    color: AppColor.dark,
                   fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
