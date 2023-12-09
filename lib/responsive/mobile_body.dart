  import 'dart:developer';

  import 'package:flutter/material.dart';
  import 'package:mavunohub/cards/news_feed.dart';
  import 'package:mavunohub/components/bottom_menu.dart';
  import 'package:mavunohub/components/drawer.dart';
  import 'package:mavunohub/cards/my_box.dart';
  import 'package:mavunohub/cards/my_tile.dart';
  import 'package:mavunohub/screens/app_screens/services.dart';

  import '../cards/updates&events.dart';
  import '../screens/app_screens/services.dart';

  class MobileScaffold extends StatefulWidget {
    final String? username; // Add this line


    const MobileScaffold({
      this.username, // Add this line
    });
    @override
    State<MobileScaffold> createState() => _MobileScaffoldState();

  of(BuildContext context) {}
  }

  class _MobileScaffoldState extends State<MobileScaffold> {
    bool loading = true;
    Widget? loadingWidget;

    @override
    void initState() {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            loading = false;
          });
        });
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: MobileAppbar(context),
        drawer: const IconMenu(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0).add(const EdgeInsets.symmetric(vertical: 10)),
                      child: SizedBox(
                        height: 25,
                        child: Text(
                        'Welcome ${widget.username}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Gilmer',
                            fontSize: 26,
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.w800,
                          ),
                        )
                      ),
                    ),
                  ),
                  // First 4 boxes in a row
                  Container(
                    height: 180, // Adjust the height as needed
                    child: Row(
                      children: [
                        Expanded(
                          child: MyBox(
                            title: 'My Tasks',
                            onClicked: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Services(),
                              ));
                            },
                          ),
                        ),
                        Expanded(
                          child: MyBox(title: 'My Status'),
                        ),
                      ],
                    ),
                  ),
                  // List of previous days
                  Container(
                    height: 220, // Adjust the height as needed
                    child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return MyTile(
                            title: 'Farm Setup',
                            action: () {
                              final snackBarHelper = SnackBarHelper(context);
                              snackBarHelper.showCustomSnackBarWithMenu();
                            },
                          );
                        } else if (index == 1) {
                          return const MyTile(title: 'Consultation Services');
                        } else if (index == 2) {
                          return const MyTile(title: 'Billings & Transactions');
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0).add(
                          const EdgeInsets.symmetric(vertical: 5)
                              .add(const EdgeInsets.only(top: 10))),
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: Container(
                      height: 220,
                      child: ListView.builder(
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: 250,
                            child: NewsFeed(),
                          );
                        },
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0).add(
                          const EdgeInsets.symmetric(vertical: 5)
                              .add(const EdgeInsets.only(top: 10))),
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      height: 150,
                      child: ListView.builder(
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: 300,
                            child: Updates(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

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
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 35,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(5.0),
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
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 2),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 0,
                  ),
                ),
                fillColor: Theme.of(context).colorScheme.secondary,
                filled: true,
                prefixIcon: Icon(Icons.search, color: Theme.of(context).hintColor),
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
