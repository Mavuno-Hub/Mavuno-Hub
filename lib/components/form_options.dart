import 'package:flutter/material.dart';

class FormDropDown extends StatefulWidget {
  final String text;
  final TextEditingController? controller;
  final String? hint;
  final IconData? prefix;
  final List<String> list;
  final VoidCallback? onClicked;

  const FormDropDown({super.key, 
  // Key? key,
  required this.text,
  this.controller,
  this.hint,
  this.prefix,
  required this.list,
  this.onClicked,
  String? label,
});
  @override
  _FormDropDownState createState() => _FormDropDownState();
}

class _FormDropDownState extends State<FormDropDown> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          style: TextStyle(
            fontFamily: 'Gilmer',
            fontSize: 14,
            color: Theme.of(context).hintColor,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: "   Select ${widget.text}",
            hintStyle: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
              fontFamily: "Gilmer",
              fontWeight: FontWeight.w700,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.secondary,
            contentPadding: const EdgeInsets.only(left: 10, right: 0, top: 10, bottom: 10),
          ),
          isExpanded: true,
          iconSize: 30,
          iconEnabledColor: Theme.of(context).colorScheme.tertiary,
          value: _selectedValue,
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
              widget.controller?.text = value!;
            });
            if (widget.onClicked != null) {
              widget.onClicked!();
            }
          },
          items: widget.list
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Gilmer",
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ))
              .toList(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a value';
            }
            return null;
          },
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 7)),
      ],
    );
  }
}
