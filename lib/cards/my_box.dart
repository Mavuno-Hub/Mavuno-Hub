import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyBox extends StatelessWidget {
  final String? title;
  final String? hint;
  final String? holder1;
  final String? holder2;
  final String? holder3;
  final String? data1;
  final String? type1;
  final String? type2;
  final String? data2;
  final String? username;
  final String? data3;
  final Future<Map<String, int>>? Function()
      opFunction; // Change the type of opFunction
  final Icon? icon;
  final VoidCallback? onClicked;
  final VoidCallback? CardPress;
  const MyBox(
      {super.key,
      this.icon,
      required this.opFunction,
      this.username,
      this.title,
      this.hint,
      this.type1,
      this.type2,
      this.data1,
      this.data2,
      this.data3,
      this.holder1,
      this.holder2,
      this.holder3,
      this.CardPress,
      this.onClicked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
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
                child: FutureBuilder<Map<String, int>>(
                    future: opFunction(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final int data1 = snapshot.data?['$type1'] ?? 0;
                        final int data2 = snapshot.data?['$type2'] ?? 0;
final data3 = data1+data2;
                        return Column(
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
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const Spacer(flex: 1),
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
                            Row(
                              children: [
                                Text(
                                  '$holder1 :',
                                  style: TextStyle(
                                    fontFamily: "Gilmer",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const Spacer(flex: 1),
                                Text(
                                  '$data1' ?? "_ _",
                                  style: TextStyle(
                                    fontFamily: "Gilmer",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.all(2.0),
                            ),
                            Row(
                              children: [
                                Text(
                                  '$holder2 :',
                                  style: TextStyle(
                                    fontFamily: "Gilmer",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const Spacer(flex: 1),
                                Text(
                                   '$data2'?? "_ _",
                                  style: TextStyle(
                                    fontFamily: "Gilmer",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.all(2.0),
                            ),
                            Row(
                              children: [
                                Text(
                                  '$holder3 :',
                                  style: TextStyle(
                                    fontFamily: "Gilmer",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const Spacer(flex: 1),
                                Text(
                                  '$data3' ?? "_ _",
                                  style: TextStyle(
                                    fontFamily: "Gilmer",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.all(2.0),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.background),
                            )
                          ],
                        );
                      } else {
                        // Show a loading indicator while the data is loading
                        return Container(
                          height: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Theme.of(context).colorScheme.secondary),
                          alignment: Alignment.center,
                          child: Center(
                              child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.tertiary,
                          )),
                        );
                      }
                    })),
          ),
        ),
      ),
    );
  }
}
