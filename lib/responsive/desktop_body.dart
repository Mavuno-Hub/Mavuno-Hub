import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mavunohub/cards/news_feed.dart';
import 'package:mavunohub/components/drawer.dart';
import 'package:mavunohub/styles/pallete.dart';
import '../cards/my_box.dart';
import '../cards/my_tile.dart';
import '../cards/updates&events.dart';
import '../components/bottom_menu.dart';
import '../screens/app_screens/billing&transactions.dart';
import '../screens/app_screens/news.dart';
import '../screens/app_screens/services.dart';
import '../screens/app_screens/view_services.dart';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mavunohub/features/rss_detailed.dart';
import 'package:xml/xml.dart' as xml;
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as html;
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed/webfeed.dart';

class DesktopScaffold extends StatefulWidget {
  final String? username; // Add this line

  const DesktopScaffold({
    this.username, // Add this line
  });
  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  bool loading = true;
  Widget? loadingWidget;
  final rssUrl = 'https://kilimonews.co.ke/agribusiness/feed/'; // RSS feed URL

  late Future<List<Map<String, String?>>> futureRss;
  late RssFeed _feed = RssFeed(items: []);
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                              return MyBox(
                                title: 'My Tasks',
                                opFunction: () =>
                                    getServiceCount(), // Pass the function correctly
                              );
                            } else if (index == 1) {
                              // Second instance of MyBox with different properties
                              return MyBox(
                                opFunction: () =>
                                    getServiceCount(), // Pass the function correctly
                                title: 'My Status',
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                    ),

                    // List Buttons
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          children: [
                            MyTile(
                              title: 'Farm Setup',
                              action: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //   builder: (context) => const ViewServices(),
                                // ));

                                final snackBarHelper = SnackBarHelper(context);
                                snackBarHelper.showCustomSnackBarWithMenu();
                              },
                            ),
                            MyTile(
                                title: 'Billing & Transactions',
                                action: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const Billing(),
                                  ));
                                }),
                            MyTile(
                              title: 'Consultation Services',
                            ),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(height: 20),
                    //News Feed
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => News(),
                          ));
                        },
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
                        aspectRatio: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Container(
                              height: 400,
                              child: SizedBox(
                                width: 420,
                                child: FutureBuilder<
                                        List<Map<String, String?>>>(
                                    future: futureRss,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator(
                                                color: AppColor.yellow));
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return Center(
                                            child: Text('No data available'));
                                      } else {
                                        return ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (context, index) {
                                              final item =
                                                  snapshot.data![index];
                                              final items = _feed.items?[index];
                                              return NewsFeed(
                                                title: item['title'],
                                                imageUrl: item['imageUrl'],
                                                onClicked: () async {
                                                  if (items?.link != null) {
                                                    await launch(items!.link!);
                                                  }
                                                },
                                                shortDescription:
                                                    item['description'],
                                              );
                                            });
                                      }
                                    }),
                              )),
                        ))
                  ],
                ),
              ),
            ),
            // second half of page
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
            ),
          ],
        ),
      ),
    );
  }
}
