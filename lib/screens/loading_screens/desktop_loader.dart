import 'package:flutter/material.dart';
import 'package:mavunohub/components/drawer.dart';
import '../../cards/my_box.dart';
import '../../cards/my_tile.dart';

class DesktopLoader extends StatefulWidget {
  const DesktopLoader({Key? key}) : super(key: key);

  @override
  State<DesktopLoader> createState() => _DesktopLoaderState();
}

class _DesktopLoaderState extends State<DesktopLoader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        toolbarHeight: 60, // Adjust the height as needed
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleSpacing: 0, // Remove default title spacing
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DesktopLoader(),
                  ));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/mavunohub_icon.png',
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(width: 8), // Add some horizontal spacing
                    Text(
                      'MavunoHub',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        fontFamily: "Gilmer",
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // open drawer
            const IconMenu(),

            // first half of page
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  // first 4 boxes in grid
                  AspectRatio(
                    aspectRatio: 
                    5,
                    child: SizedBox(
                      width: double.infinity,
                      child: GridView.builder(
                        itemCount: 2,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisExtent: 4 ),
                        itemBuilder: (context, index) {
                          return const MyBox();
                        },
                      ),
                    ),
                  ),

                  // list of previous days
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical:8.0),
                      child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return const MyTile();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // second half of page
            Expanded(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.primary,
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
