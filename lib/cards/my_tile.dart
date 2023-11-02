import 'package:flutter/material.dart';

import '../styles/pallete.dart';

class MyTile extends StatelessWidget {
  final String? title;
  final VoidCallback? action;
  // final Widget Function(BuildContext)? action;
  const MyTile({super.key, 

    this.title,
    this.action
  });

  @override
  Widget build(BuildContext context) {
    // return Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: PhysicalModel(
    //     clipBehavior: Clip.none,
    //     color: Theme.of(context).colorScheme.secondary,
    //     borderRadius: BorderRadius.circular(15),
    //     child: Center(
    //       child: Container(
    //           height: 78,
    //           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(8),
    //               color: Theme.of(context).colorScheme.secondary),
    // child: ListTile(
    //     dense: true,
    //     title: Transform.translate(
    //         offset: const Offset(-15, 10),
    //         child: Text(
    //           title ?? "Tile Title",
    //           style: TextStyle(
    //               color: Theme.of(context).colorScheme.onBackground,
    //               fontFamily: 'Gilmer',
    //               fontSize: 24,
    //               fontWeight: FontWeight.w800),
    //         )),
    // trailing: Transform.translate(
    //     offset: const Offset(-0, 10),
    //     child: Container(
    //       color: Theme.of(context).colorScheme.tertiary,
    //       child: Row(
    //         children: [
    //           Text(
    //             'Click Here',
    //             style: TextStyle(
    //                 color:
    //                     Theme.of(context).colorScheme.background),
    //           )
    //         ],
    //       ),
    //                   )))),
    //     ),
    //   ),
    // );
    return GestureDetector(
  // onTap: () {
  //           Navigator.of(context).push(MaterialPageRoute(
  //             builder: (context) => action!(context), // Call the action function
  //           ));
  //         },
  onTap: action,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Text(
                    title ?? "Tile Title",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontFamily: 'Gilmer',
                        fontSize: 14,
                        fontWeight: FontWeight.w800),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  Center(
                    child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).colorScheme.tertiary),
                        child: const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Text(
                                'Click Here',
                                style: TextStyle(
                                    fontFamily: 'Gilmer',
                                    fontSize: 12,
                                   fontWeight: FontWeight.w700,
                                    color: AppColor.dark),
                              ),
                            )
                          ],
                        )),
                  )
                  // Center(
                  //   child: Stack(
                  //     children: [
                  //       Container(
                  //         height: 25,
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(8),
                  //             color: Theme.of(context).colorScheme.tertiary),
                  //       ),
                  //       const Text(
                  //         'Click Here',
                  //         style: TextStyle(
                  //             fontFamily: 'Gilmer',
                  //             fontSize: 12,
                  //            fontWeight: FontWeight.w700,
                  //             color: AppColor.dark),
                  //       )
                  //     ],
                  //   ),
                  // )
                ],
              ),
            )),
      ),
    );
  }
}
