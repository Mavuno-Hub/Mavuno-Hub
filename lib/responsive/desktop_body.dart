import 'package:flutter/material.dart';
import 'package:mavunohub/components/drawer.dart';
import '../cards/my_box.dart';
import '../cards/my_tile.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({super.key});

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      // appBar: myAppBar,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // open drawer
            const IconMenu(),
            // first half of page
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  // My Tasks & My Status
                  AspectRatio(
                    aspectRatio: 4,
                    child: SizedBox(
                      width: double.infinity,
                      child: GridView.builder(
                        itemCount: 2,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Ensures 2 cards per
                          // childAspectRatio: 1.0, // Maintain square aspect ratio
                        ),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            // First instance of MyBox with different properties
                            return const MyBox(
                              title: 'My Tasks',
                            );
                          } else if (index == 1) {
                            // Second instance of MyBox with different properties
                            return const MyBox(
                                // title: 'My Status',
                                );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ),

                  // List Buttons
                  const SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          MyTile(
                            title: 'Farm Setup',
                          ),
                          MyTile(
                            title: 'Consultation Services',
                          ),
                          MyTile(
                            title: 'Billing & Transactions',
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(height: 20),
                  //News Feed
                  GestureDetector(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'News Feed',
                          style: TextStyle(
                            fontFamily: 'Gilmer',
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                           fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(flex: 1),
                        Text(
                          'More',
                          style: TextStyle(
                            fontFamily: 'Gilmer',
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.tertiary,
                           fontWeight: FontWeight.w700,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: Theme.of(context).colorScheme.tertiary,
                        )
                      ],
                    ),
                  )),
               AspectRatio(
              aspectRatio: 2,
              child: SizedBox(
                width: double.infinity,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // childAspectRatio: 1.0, // Maintain square aspect ratio
                  ),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // First instance of MyBox with different properties
                      return const MyBox(
                        title: 'My Tasks',
                      );
                    } else if (index == 1) {
                      // Second instance of MyBox with different properties
                      return const MyBox(
                        title: 'My Status',
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            )
                ],
              ),
            ),
            // second half of page
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  // list of stuff
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
