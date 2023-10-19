import 'package:flutter/material.dart';
import 'package:mavunohub/styles/pallete.dart';

class MyBox extends StatelessWidget {
  final String? title;
  final String? hint;
  final String? desc;
  final Color? color;
  const MyBox({
    Key? key,
    this.title,
    this.desc,
    this.hint,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ??
                      "Card Title", // Use a default value (empty string) if widget.text is null
                  style: const TextStyle(
                    fontFamily: "Gilmer",
                    fontSize: 24,
                   fontWeight: FontWeight.w700,
                    color: AppColor.yellow,
                  ),
                  textAlign: TextAlign.left,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0).add(const EdgeInsets.only(bottom: 2)),
                  child: Text(
                    hint ?? "Description of the card data",
                    style: TextStyle(
                      fontFamily: "Gilmer",
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context)
                          .hintColor
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                // ListView.builder(
                //   itemCount: 4,
                //   itemBuilder: (context, index) {
                Container(
                  color: Theme.of(context).colorScheme.background,
                  child: Text(
                    desc ?? "Details",
                    style: TextStyle(
                      fontFamily: "Gilmer",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground, // Use a default color if widget.color is null
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  color: Theme.of(context).colorScheme.background,
                  child: Text(
                    desc ?? "Details",
                    style: TextStyle(
                      fontFamily: "Gilmer",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground, // Use a default color if widget.color is null
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  color: Theme.of(context).colorScheme.background,
                  child: Text(
                    desc ?? "Details",
                    style: TextStyle(
                      fontFamily: "Gilmer",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground, // Use a default color if widget.color is null
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                //   },
                // ),
              ],
            ),
          ),
        ));
  }
}
