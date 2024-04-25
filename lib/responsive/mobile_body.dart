import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mavunohub/components/bottom_menu.dart';
import 'package:mavunohub/main.dart';
import 'package:xml/xml.dart' as xml;
import 'package:html/parser.dart' as htmlParser;
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed/webfeed.dart';
import '../cards/news_feed.dart';
import '../cards/my_box.dart';
import '../cards/my_tile.dart';
import '../cards/updates&events.dart';
import '../components/drawer.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
// import 'custom_tooltip.dart';
import '../components/overlay_button.dart';
import '../screens/app_screens/news.dart';
import '../screens/app_screens/services.dart';
import '../styles/pallete.dart';

class MobileScaffold extends StatefulWidget {
  final String? username;

  const MobileScaffold({
    this.username,
  });

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
  bool done = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();
  final TooltipController _controller = TooltipController();
  bool loading = true;
  late Future<List<Map<String, String?>>> futureRss;
  late RssFeed _feed = RssFeed(items: []);

  final rssUrl = 'https://kilimonews.co.ke/agribusiness/feed/';

  Future<List<Map<String, String?>>> parseRss(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch RSS feed');
    }

    final rawRss = response.body;
    final document = xml.XmlDocument.parse(rawRss);

    final items = <Map<String, String?>>[];

    for (final node in document.findAllElements('item')) {
      final title = node.findElements('title').firstOrNull?.text;
      final contentEncoded =
          node.findElements('content:encoded').firstOrNull?.text;
      final description = node.findElements('description').firstOrNull?.text;

      String? imageUrl;

      if (contentEncoded != null) {
        final document = htmlParser.parse(contentEncoded);
        final imgElement = document.querySelector('img');

        if (imgElement != null) {
          imageUrl = imgElement.attributes['src'];
        }
      }

      if (title != null) {
        items.add({
          'title': title,
          'imageUrl': imageUrl,
          'description': description,
        });
      }
    }

    final xmlString = response.body;
    final channel = RssFeed.parse(xmlString);
    setState(() {
      _feed = channel;
    });
    return items;
  }

  @override
  void initState() {
    super.initState();
    futureRss = parseRss(rssUrl);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          loading = false;
        });
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<Map<String, int>> getServiceCount() async {
    try {
      final QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: widget.username)
          .get();

      String userDocId = userQuery.docs.first.id;
      final QuerySnapshot querySnapshotService = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userDocId)
          .collection('services')
          .get();
      final QuerySnapshot querySnapshotAssets = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDocId)
          .collection('assets')
          .get();

      int serviceCount = querySnapshotService.size;
      int assetCount = querySnapshotAssets.size;

      return {'services': serviceCount, 'assets': assetCount};
    } catch (e) {
      print(e);
      return {'services': 0, 'assets': 0}; // Return 0 in case of an error
    }
  }

  Widget build(BuildContext context) {
    return OverlayTooltipScaffold(
      // overlayColor: Colors.red.withOpacity(.4),
      tooltipAnimationCurve: Curves.linear,
      tooltipAnimationDuration: const Duration(milliseconds: 1000),
      controller: _controller,
      startWhen: (initializedWidgetLength) async {
        await Future.delayed(const Duration(milliseconds: 500));
        return initializedWidgetLength == 5 && !done; // Check if user has not interacted before
      },
      preferredOverlay: GestureDetector(
        onTap: () {
          _controller.dismiss();
          //move the overlay forward or backwards, or dismiss the overlay
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.6),
            border: Border.all(
              // color: Theme.of(context).colorScheme.tertiary, // Specify the color of the border
              width: 1, // Specify the width of the border
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            // blendMode: BlendMode.multiply,
            child: Container(
              // color:  Theme.of(context).colorScheme.tertiary.withOpacity(0.5), // Specify the color of the border


            ),
          ),
        ),

      ),
      builder: (context) => Scaffold(
        key: _scaffoldKey,
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
                      padding: const EdgeInsets.symmetric(horizontal: 15.0)
                          .add(const EdgeInsets.symmetric(vertical: 10)),
                      child: SizedBox(
                        height: 30,
                        child: Text(
                          'Welcome ${widget.username}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Gilmer',
                            fontSize: 26,
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 180,
                    child: Row(
                      children: [
                        Expanded(
                          // height: 180,
                          // width: double.infinity,
                          child: Row(
                            children: [
                              Expanded(
                                child: OverlayTooltipItem(
                                  displayIndex: 4,
                                  tooltip: (controller) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: OverlayButton(
                                          title: 'User Guide:',
                                          desc: 'Onboarding tutorial for important features',
                                          controller: controller),
                                    );
                                  },
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: MyBox(
                                      title: 'My Tasks',
                                      holder1: 'Pending',
                                      opFunction: () => getServiceCount(),
                                      holder2: 'Complete',
                                      holder3: 'All',
                                      type1: 'assets',
                                      type2: 'services',
                                      onClicked: () {
                                        OverlayTooltipScaffold.of(context)?.controller.start();
                                        // Navigator.of(context)
                                        //     .push(MaterialPageRoute(
                                        //   builder: (context) =>
                                        //       const Services(),
                                        // ));
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: OverlayTooltipItem(
                                  displayIndex: 0,
                                  tooltip: (controller) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: OverlayButton(
                                          title: 'One Pager',
                                          desc: 'View all your assets and services available',
                                          // desc: 'View all your assets and services available',
                                          controller: controller),
                                    );
                                  },
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: MyBox(
                                      title: 'My Status',
                                      holder1: 'Assets',
                                      holder2: 'Services',
                                      holder3: 'All',
                                      opFunction: () => getServiceCount(),
                                      type1: 'assets',
                                      type2: 'services',
                                      onClicked: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const Services(),
                                          ),
                                        );
                                      },
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
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return OverlayTooltipItem(
                            displayIndex: 1,
                            tooltip: (controller) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: OverlayButton(
                                    title: 'Setup you farm ',
                                    desc: 'Add Assets and Services',
                                    controller: controller),
                              );
                            },
                            child: MyTile(
                              title: 'Farm Setup',
                              action: () {
                                final snackBarHelper = SnackBarHelper(context);
                                snackBarHelper.showCustomSnackBarWithMenu();
                              },
                            ),
                          );
                        } else if (index == 1) {
                          return OverlayTooltipItem(
                              displayIndex: 2,
                              tooltip: (controller) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: OverlayButton(
                                      title: 'Get guidance from the best',
                                      desc: 'Click and get 5 USD (For Free)',
                                      controller: controller),
                                );
                              },child: MyTile(title: 'Consultation Services'));
                        } else if (index == 2) {
                          return OverlayTooltipItem(
                            displayIndex: 3,
                            tooltip: (controller) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: OverlayButton(
                                    title: 'Transaction Records',
                                    desc: 'Click and get 5 USD (For Free)',
                                    controller: controller),
                              );
                            },
                            child: MyTile(
                                title: 'Billings & Transactions',
                                action: () {
                                  final snackBarHelper = SnackBarHelper(context);
                                  snackBarHelper.showPaymentOptions();
                                }),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => News(),
                      ));
                    },
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
                  Container(
                    height: 300,
                    child: SizedBox(
                      // width: 420,
                      child: FutureBuilder<List<Map<String, String?>>>(
                        future: futureRss,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Container(
                                height: 300,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                alignment: Alignment.center,
                                child: Center(
                                    child: CircularProgressIndicator(
                                  color: Theme.of(context).colorScheme.tertiary,
                                )),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text('No data available'));
                          } else {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final item = snapshot.data![index];
                                final items = _feed.items?[index];
                                return NewsFeed(
                                  title: item['title'],
                                  imageUrl: item['imageUrl'],
                                  onClicked: () async {
                                    if (items?.link != null) {
                                      await launch(items!.link!);
                                    }
                                  },
                                  shortDescription: item['description'],
                                );
                              },
                            );
                          }
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
        // floatingActionButton:
        // OverlayTooltipItem(
        //   displayIndex: 5,
        //   tooltip: (controller) => Padding(
        //     padding: const EdgeInsets.only(bottom: 15),
        //     child:
        //         OverlayButton(title: 'Floating button', controller: controller),
        //   ),
        //   tooltipVerticalPosition: TooltipVerticalPosition.TOP,
        //   child:
        //   FloatingActionButton(
        //     backgroundColor: Theme.of(context).colorScheme.tertiary,
        //     onPressed: () {
        //
        //       OverlayTooltipScaffold.of(context)?.controller.start();
        //     },
        //     child:  Icon(Icons.lightbulb, color: Theme.of(context).colorScheme.background),
        //   ),
        // ),
      ),
    );
  }
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
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
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
