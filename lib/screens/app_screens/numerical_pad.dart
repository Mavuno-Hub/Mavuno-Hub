import 'package:flutter/material.dart';

class NumericPad extends StatelessWidget {
  final Function(int) onNumberSelected;

  const NumericPad({super.key, required this.onNumberSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F4F9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int row = 0; row < 4; row++)
            buildRow(context, [1, 2, 3], row),
        ],
      ),
    );
  }

  Widget buildRow(BuildContext context, List<int> numbers, int row) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int number in numbers)
            buildNumberButton(number),
        ],
      ),
    );
  }

  Widget buildNumberButton(int number) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onNumberSelected(number);
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBackspaceButton() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onNumberSelected(-1);
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 3, 3, 3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: Icon(
                Icons.backspace,
                size: 28,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
