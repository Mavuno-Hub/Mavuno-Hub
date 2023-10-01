import 'package:flutter/material.dart';


class FormField extends StatefulWidget {
  final String text;
  final String? hint;
  final TextEditingController? controller;
  final IconData? prefix;
  final IconData? suffix;
  final VoidCallback? onClicked;
  final String? label;

  const FormField({
    Key? key,
     required this.text,
   this.hint,
    this.controller,
    this.prefix,
    this.suffix,
    this.onClicked,
    this.label,
  }) : super(key: key);

  @override
  State<FormField> createState() => _FormFieldState();
}

class _FormFieldState extends State<FormField> {
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.text,
            textAlign: TextAlign.start,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 14,
              color:Theme.of(context).colorScheme.primary,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 3)),
        TextFormField(
          
          maxLines: 3,
          controller: widget.controller,
          cursorColor: Theme.of(context).colorScheme.primary,
          minLines: 1,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter ${widget.text}';
            }
            return null;
          },
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w300,
          ),
          decoration: InputDecoration(
            hintText: "Enter ${widget.text}",
            hintStyle: TextStyle(
              fontSize: 14,
              color:Theme.of(context).colorScheme.primary,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w100,
            ),
            focusColor: Theme.of(context).colorScheme.primary,
            suffixIcon: Icon(widget.suffix, color: Theme.of(context).colorScheme.primary,),
            isDense: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            ),
            fillColor: Color.fromARGB(64, 236, 236, 236),
            filled: true,
          
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color:Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 7)),
      ],
    );
  }
}
