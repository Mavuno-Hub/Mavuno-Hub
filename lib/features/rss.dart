import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mavunohub/features/rss_detailed.dart';
import 'package:xml/xml.dart' as xml;
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as html;
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed/webfeed.dart';

import '../styles/pallete.dart';

class NewsRSS extends StatefulWidget {
  @override
  _NewsRSSState createState() => _NewsRSSState();
  final String? imageUrl;
  final String? title;
  final String? shortDescription;
  final VoidCallback? onClicked;

  const NewsRSS(
      {super.key,
      this.imageUrl,
      this.title,
      this.shortDescription,
      this.onClicked});
}

class _NewsRSSState extends State<NewsRSS> {
  final baseUrl ='https://kilimonews.co.ke/agribusiness/feed/'; 
  final rssUrl = 'https://kilimonews.co.ke/agribusiness/feed/'; // RSS feed URL
  late Future<List<Map<String, String?>>> futureRss;
  late RssFeed _feed = RssFeed(items: []);
  Map<String, String> headers = {
      "Content-Type": "text/plain",
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      //  "auth-token": idToken, // whatever headers you need(I add auth)
      "content-type":
          "application/json", // Specify content-type as JSON to prevent empty response body

      // "Access-Control-Allow-Credentials": true, // Required for cookies, authorization headers with HTTPS
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      'Accept': '*/*',
      "Access-Control-Allow-Methods": "POST, OPTIONS"
    };
  Future<List<Map<String, String?>>> parseRss(String url) async {
    final response = await http.get(Uri.parse(url),headers: headers);
    
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
        body: FutureBuilder<List<Map<String, String?>>>(
          future: futureRss,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(color: AppColor.yellow));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              return Center(
                child: SizedBox(
                  width: 420,
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];
                      final items = _feed.items?[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () async {
                            if (items?.link != null) {
                              await launch(items!.link!);
                            }
                          },
                          hoverColor: Theme.of(context)
                              .colorScheme
                              .background
                              .withOpacity(1),
                          child: Container(
                            height: 350,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item['imageUrl'] != null)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                      child: Image.network(
                                        item['imageUrl']!,
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                if (item['imageUrl'] == null)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0).add(
                                    const EdgeInsets.symmetric(horizontal: 6.0),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 320,
                                        child: Text(
                                          item['title'] ?? '',
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: SizedBox(
                                    width: 320,
                                    child: Text(
                                      item['description'] ?? '',
                                      style: TextStyle(
                                        fontFamily: "Gilmer",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                const Spacer(flex: 1),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2.0,
                                  ).add(const EdgeInsets.all(8.0)),
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
              );
            }
          },
        ));
  }
}
