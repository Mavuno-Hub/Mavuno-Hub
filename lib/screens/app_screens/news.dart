import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed/webfeed.dart';

class News extends StatefulWidget {
  @override
  NewsState createState() => NewsState();
}

class NewsState extends State<News> {
  late RssFeed _feed = RssFeed(items: []);
  static const String placeholderImg = 'assets/no-image.png';
  late String _title;
  Future<void> loadFeed() async {
    try {
      final String FEED_URL = 'https://kilimonews.co.ke/agribusiness/feed/';
      final client = http.Client();
      final response = await client.get(Uri.parse(FEED_URL),headers:  {
  "Access-Control-Allow-Origin": "*", // Required for CORS support to work
  // "Access-Control-Allow-Credentials": true, // Required for cookies, authorization headers with HTTPS
  "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
  "Access-Control-Allow-Methods": "POST, OPTIONS"
},);
      final xmlString = response.body;
      final channel = RssFeed.parse(xmlString);
      setState(() {
        _feed = channel;
      });
    } catch (e) {
      print('Error loading RSS feed: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,
              color: Theme.of(context).colorScheme.tertiary),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              "assets/mavunohub_icon.png",
              width: 25,
            ),
            iconSize: 35,
            onPressed: () {
              Navigator.of(context).pop();
            },
            // onPressed: onClickedHome,
          ),
          const Padding(padding: EdgeInsets.all(10)),
        ],
        elevation: 0.0,
        title: Text(
          'News Feed',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontFamily: 'Gilmer',
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),
        toolbarHeight: 75,
        // centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.background,
                Theme.of(context).colorScheme.background
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          padding: const EdgeInsets.only(bottom: 38),
        ),
      ),
      body: _feed.items!.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.background,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.background),
              ),
            )
          : Center(
              child: SizedBox(
                width: 420,
                child: ListView.builder(
                  itemCount: _feed.items?.length ?? 0,
                  itemBuilder: (context, index) {
                    final item = _feed.items?[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          if (item?.link != null) {
                            await launch(item!.link!);
                          }
                        },
                        hoverColor: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(1),
                        child: Container(
                          height: 250, // Adjust the height as needed
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item?.enclosure?.url != null)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    ),
                                    child: Image.network(
                                      item!.enclosure!.url!,
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              if (item?.enclosure?.url == null)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    ),
                                  ),
                                ),
                              // Spacer(flex: 1),
                              Padding(
                                padding: const EdgeInsets.all(2.0).add(
                                    const EdgeInsets.symmetric(
                                        horizontal: 6.0)),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 320,
                                      child: Text(
                                        item?.title ?? '',
                                        style: TextStyle(
                                          fontFamily: "Gilmer",
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    const Spacer(flex: 1),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Icon(
                                        Icons.arrow_forward,
                                        size: 18,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  item?.description ?? '',
                                  style: TextStyle(
                                    fontFamily: "Gilmer",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                  // overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                  textAlign: TextAlign.left,
                                ),
                              ),

                              const Spacer(flex: 1),

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0)
                                        .add(const EdgeInsets.all(8.0)),
                                child: Row(
                                  children: [
                                    Text(
                                      'Click for more information',
                                      style: TextStyle(
                                        fontFamily: "Gilmer",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.left,
                                    ),
                                    const Spacer(flex: 1),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
