import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mavunohub/components/bottom_menu.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:xml/xml.dart' as xml;
import 'package:html/parser.dart' as htmlParser;
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed/webfeed.dart';
import '../cards/news_feed.dart';
import '../cards/my_box.dart';
import '../cards/my_tile.dart';
import '../cards/updates&events.dart';
import '../components/drawer.dart';
// import '../components/Showcase.dart';
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
  final GlobalKey _myTasksKey = GlobalKey();
  final GlobalKey _myStatusKey = GlobalKey();
  final GlobalKey _farmSetupKey = GlobalKey();
  final GlobalKey _consultationKey = GlobalKey();
  final GlobalKey _transactionsKey = GlobalKey();
  final GlobalKey _newsFeedKey = GlobalKey();

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
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
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
                    padding: const EdgeInsets.symmetric(horizontal: 15.0)
                        .add(const EdgeInsets.symmetric(vertical: 10)),
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
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 180,
                  child: Row(
                    children: [
                      Expanded(
                        child: Showcase(
                          key: _myTasksKey,
                          title: 'My Tasks',
                          description: 'Click here to manage your tasks!',
                          child: MyBox(
                            title: 'My Tasks',
                            onClicked: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Services(),
                              ));
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Showcase(
                          key: _myStatusKey,
                          title: 'My Status',
                          description: 'Click here to see your status',
                          child: const MyBox(title: 'My Status'),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 220,
                  child: ListView.builder(
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Showcase(
                          key: _farmSetupKey,
                          title: 'Farm Setup',
                          description: 'Explore the latest news here!',
                          child: MyTile(
                            title: 'Farm Setup',
                            action: () {
                              final snackBarHelper = SnackBarHelper(context);
                              snackBarHelper.showCustomSnackBarWithMenu();
                            },
                          ),
                        );
                      } else if (index == 1) {
                        return Showcase(
                          key: _consultationKey,
                          title: 'Consultation Services',
                          description: 'Explore the latest news here!',
                          child: const MyTile(title: 'Consultation Services'),
                        );
                      } else if (index == 2) {
                        return Showcase(
                          key: _transactionsKey,
                          title: 'Billings & Transactions',
                          description: 'Explore the latest news here!',
                          child: const MyTile(title: 'Billings & Transactions'),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10.0)
                        .add(const EdgeInsets.symmetric(vertical: 5)
                        .add(const EdgeInsets.only(top: 10))),
                    child: Row(
                      children: [
                        Showcase(
                          key: _newsFeedKey,
                          title: 'News Feed',
                          description: 'Explore the latest news here!',
                          child: Text(
                            'News Feed',
                            style: TextStyle(
                              fontFamily: 'Gilmer',
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                              fontWeight: FontWeight.w700,
                            ),
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
                    width: 420,
                    child: FutureBuilder<List<Map<String, String?>>>(
                      future: futureRss,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColor.yellow,
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
                    padding: const EdgeInsets.symmetric(horizontal: 10.0)
                        .add(const EdgeInsets.symmetric(vertical: 5)
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
