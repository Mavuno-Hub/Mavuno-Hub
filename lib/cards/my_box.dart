import 'package:flutter/material.dart';

class MyBox extends StatelessWidget {
  final String? title;
  final String? hint;
  final Icon? icon;
  final VoidCallback? onClicked;

  final VoidCallback? CardPress;
  const MyBox(
      {super.key,
      this.icon,
      this.title,
      this.hint,
      this.CardPress,
      this.onClicked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:  GestureDetector(
        onTap: onClicked,
        child: Container(
          height: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.secondary),
          child: Padding(
            padding:
                const EdgeInsets.all(15.0).add(const EdgeInsets.only(top: 15)),
            child: SizedBox(
              // height: MediaQuery.of(context).size.height /
              //     2, // Half the screen height
              // height: 50,
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text(
                        title ?? "No Update",
                        style: TextStyle(
                          fontFamily: "Gilmer",
                          fontSize: 22,
                         fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      // Spacer(flex: 1),
                      // IconButton(
                      //   onPressed: CardPress,
                      //   icon: Icon(
                      //     icon as IconData?,
                      //     color: Theme.of(context).colorScheme.tertiary,
                      //   ),
                      // )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(2.0),
                  ),
                  Text(
                    hint ?? "No Data",
                    style: TextStyle(
                      fontFamily: "Gilmer",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).hintColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                    const Padding(
                    padding: EdgeInsets.all(2.0),
                  ),
                  Container(
                      child: Text(
                    hint ?? 'No Details',
                    style: TextStyle(
                      fontFamily: "Gilmer",
                      fontSize: 14,
                     fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    textAlign: TextAlign.left,
                  )),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
