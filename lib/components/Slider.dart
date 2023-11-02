import 'package:flutter/material.dart';

class FormSlider extends StatefulWidget {
  final String text;
  final ValueChanged<int>? onChanged; // Add callback function parameter
  final String? hint;
  final IconData? prefix;
  final VoidCallback? onClicked;

  const FormSlider({super.key, 
    // Key? key, // Add key parameter
    required this.text,
    this.onChanged,
    this.hint,
    this.prefix,
    this.onClicked,
  });

  @override
  _FormSliderState createState() => _FormSliderState();
}

class _FormSliderState extends State<FormSlider> {
  double? _sliderValue; // Use a nullable double to check if the slider has been interacted with
  int _sliderLevel = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Slider(
            min: 0,
            max: 1,
            overlayColor: MaterialStateColor.resolveWith(
                (states) => Theme.of(context).colorScheme.tertiary),
            thumbColor: MaterialStateColor.resolveWith(
                (states) => Theme.of(context).colorScheme.tertiary),
            activeColor: MaterialStateColor.resolveWith(
                (states) => Theme.of(context).colorScheme.tertiary),
            inactiveColor: MaterialStateColor.resolveWith(
                (states) => Theme.of(context).colorScheme.secondary),
            value: _sliderValue ?? 0.0, // Use the nullable value
            onChanged: (newValue) {
              setState(() {
                _sliderValue = newValue;
                _sliderLevel = (_sliderValue! * 10).round();
              });

              // Call the callback function to collect user data
              if (widget.onChanged != null) {
                widget.onChanged!(_sliderLevel);
              }
            },
            divisions: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0).add(
              const EdgeInsets.symmetric(horizontal: 20),
            ),
            child: Text(
              _sliderValue != null // Check if the slider has been interacted with
                  ? 'Status: ${_sliderLevel.toString()}'
                  : 'Please slide the slider to set the status',
              style: TextStyle(
                color: _sliderValue != null
                    ? Theme.of(context).colorScheme.tertiary
                    : Colors.red, // Show error message in red
                fontFamily: 'Gilmer',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
