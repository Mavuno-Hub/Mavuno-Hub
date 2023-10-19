import 'package:flutter/material.dart';
import 'package:mavunohub/cards/news_feed.dart';
import 'package:mavunohub/components/drawer.dart';
import 'package:mavunohub/cards/my_box.dart';
import 'package:mavunohub/cards/my_tile.dart';

import '../cards/updates&events.dart';

class MobileScaffold extends StatefulWidget {
  const MobileScaffold({Key? key}) : super(key: key);

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: MobileAppbar(context),
      drawer: const IconMenu(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          child: Column(
            children: [
              // first 4 boxes in grid
              AspectRatio(
                aspectRatio: 2,
                child: SizedBox(
                  width: double.infinity,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
              ),
              // list of previous days
              // Expanded(
              Expanded(
                flex: 2,
                child: Center(
                  child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // First instance of MyBox with different properties
                          return const MyTile(
                            title: 'Farm Setup',
                          );
                        } else if (index == 1) {
                          // Second instance of MyBox with different properties
                          return const MyTile(
                            title: 'Consultation Services',
                          );
                        } else if (index == 2) {
                          // Second instance of MyBox with different properties
                          return const MyTile(
                            title: 'Billings & Transactions',
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                ),
              ),
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ListView.builder(
                      itemCount: 5,
                      scrollDirection:
                          Axis.horizontal, // Set scroll direction to horizontal
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // First instance of NewsFeed with different properties
                          return const SizedBox(
                            width: 130, // Specify the width of the widget
                            child: NewsFeed(),
                          );
                        } else if (index == 1) {
                          // Second instance of NewsFeed with different properties
                          return const SizedBox(
                            width: 130, // Specify the width of the widget
                            child: NewsFeed(),
                          );
                        } else if (index == 2) {
                          // Third instance of NewsFeed with different properties
                          return const SizedBox(
                            width: 130, // Specify the width of the widget
                            child: NewsFeed(),
                          );
                        } else if (index == 3) {
                          // Fourth instance of NewsFeed with different properties
                          return const SizedBox(
                            width: 130, // Specify the width of the widget
                            child: NewsFeed(),
                          );
                        } else if (index == 4) {
                          // Fifth instance of NewsFeed with different properties
                          return const SizedBox(
                            width: 130, // Specify the width of the widget
                            child: NewsFeed(),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ),
              ),
              GestureDetector(
                  child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Text(
                      'Updates & Events',
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: .0),
                child: AspectRatio(
                  aspectRatio: 3,
                  child: SizedBox(
                    width: double.infinity,
                    child: ListView.builder(
                      itemCount: 5,
                      scrollDirection:
                          Axis.horizontal, // Set scroll direction to horizontal
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // First instance of NewsFeed with different properties
                          return const SizedBox(
                            width: 200, // Specify the width of the widget
                            child: Updates(),
                          );
                        } else if (index == 1) {
                          // Second instance of NewsFeed with different properties
                          return const SizedBox(
                            width: 200, // Specify the width of the widget
                            child: Updates(),
                          );
                        } else if (index == 2) {
                          // Third instance of Updates with different properties
                          return const SizedBox(
                            width: 200, // Specify the width of the widget
                            child: Updates(),
                          );
                        } else if (index == 3) {
                          // Fourth instance of Updates with different properties
                          return const SizedBox(
                            width: 200, // Specify the width of the widget
                            child: Updates(),
                          );
                        } else if (index == 4) {
                          // Fifth instance of Updates with different properties
                          return const SizedBox(
                            width: 200, // Specify the width of the widget
                            child: Updates(),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  AppBar MobileAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const MobileScaffold(),
              ));
            },  
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset('assets/mavunohub_icon.png',
                      width: 28, height: 28),
                ),
              ],
            ),
          ),
        ),
      ],
      centerTitle: true, // Center the title
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 35,
          width:
              double.infinity, // Make the TextField take up the available width
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .secondary, // Set the background color of the search bar
            borderRadius: BorderRadius.circular(
                5.0), // Adjust the border radius as needed
          ),
          child: TextFormField(
            maxLines: 1,
            minLines: 1,
            cursorColor: Theme.of(context).colorScheme.tertiary,
            style: TextStyle(
              fontFamily: 'Gilmer',
              fontSize: 14,
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.w300,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
                fontFamily: "Gilmer",
                fontWeight: FontWeight.w500,
              ),
              focusColor: Theme.of(context).colorScheme.tertiary,
              isDense:
                  true, // Set this to true to reduce the height of the input field
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 2), // Adjust the vertical padding as needed
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 0,
                ),
              ),
              fillColor: Theme.of(context).colorScheme.secondary,
              filled: true,
              prefixIcon:
                  Icon(Icons.search, color: Theme.of(context).hintColor),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.tertiary,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
