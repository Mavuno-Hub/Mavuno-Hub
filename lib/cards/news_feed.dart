import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mavunohub/features/rss_detailed.dart';
import 'package:xml/xml.dart' as xml;
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as html;
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed/webfeed.dart';

class NewsFeed extends StatefulWidget {
  final String? imageUrl;
  final String? title;
  final String? shortDescription;
  final VoidCallback? onClicked;

  const NewsFeed(
      {super.key,
      this.imageUrl,
      this.title,
      this.shortDescription,
      this.onClicked});

  @override
  State<NewsFeed> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
   Map<String, String> headers = {
          'Content-Type': 'text/plain', // Adjust this based on your needs
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      //  "auth-token": idToken, // whatever headers you need(I add auth) // Specify content-type as JSON to prevent empty response body
       "Access-Control-Allow-Methods": "GET,PUT,POST,DELETE,PATCH,OPTIONS",
      // "Access-Control-Allow-Credentials": true, // Required for cookies, authorization headers with HTTPS
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      'Accept': '*/*'
    };
    
  final rssUrl = 'https://kilimonews.co.ke/agribusiness/feed/'; // RSS feed URL
  late Future<List<Map<String, String?>>> futureRss;
  late RssFeed _feed = RssFeed(items: []);
  Future<List<Map<String, String?>>> parseRss(String rssUrl) async {
    final response = await http.get(Uri.https(rssUrl),headers: headers);

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
    futureRss = parseRss( rssUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: GestureDetector(
        onTap: widget.onClicked,
        child: Container(
          child: Column(
            children: [
              Container(
                height: 260,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      widget.imageUrl != null
                          ? Container(
                              child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        8), // Adjust the value as needed
                                    child: Image.network(
                                      widget.imageUrl!,
                                      height: 150,
                                      width: 180,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.all(2.0)
                            .add(const EdgeInsets.symmetric(horizontal: 4)),
                        child: Row(
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 260,
                                    child: Text(
                                      widget.title ?? "No News",
                                      style: TextStyle(
                                        fontFamily: "Gilmer",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(flex: 1),
                            Icon(
                              Icons.open_in_new,
                              size: 20,
                              color: Theme.of(context).colorScheme.tertiary,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0)
                            .add(const EdgeInsets.symmetric(horizontal: 4)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 280,
                              child: Text(
                                widget.shortDescription ??
                                    "Description of the News Feed",
                                style: TextStyle(
                                    fontFamily: "Gilmer",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).hintColor),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 1),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0).add(
                            const EdgeInsets.symmetric(horizontal: 4).add(
                                const EdgeInsets.only(top: 0)
                                    .add(const EdgeInsets.only(bottom: 4))),
                          ),
                          
                          child: Container(
                            decoration: BoxDecoration(
                              // color: Theme.of(context).colorScheme.tertiary.withOpacity(0.05),
                              color: Colors.transparent,
                               borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                // Container(
                                //   child: Text(
                                //     "Click to view more",
                                //     style: TextStyle(
                                //       fontFamily: "Gilmer",
                                //       fontSize: 10,
                                //       fontWeight: FontWeight.w700,
                                //       color:
                                //           Theme.of(context).colorScheme.tertiary,
                                //     ),
                                //     textAlign: TextAlign.left,
                                //   ),
                                // ),
                                // Icon(
                                //   Icons.arrow_right_rounded,
                                //   size: 18,
                                //   color: Theme.of(context).colorScheme.tertiary,
                                // ),
                                // const Spacer(flex: 1),
                                 GestureDetector(
                                  onTap: (){},
                                   child: Padding(
                                     padding: const EdgeInsets.all(2.0),
                                     child: Icon(
                                      Icons.thumb_up_alt,
                                      size: 18,
                                      color: Theme.of(context).colorScheme.surface,
                                                                   ),
                                   ),
                                 ),
                                 Container(
                                  child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                    child: Text(
                                      "Helpful",
                                      style: TextStyle(
                                        fontFamily: "Gilmer",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color:
                                            Theme.of(context).colorScheme.onBackground,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){},
                                   child: Padding(
                                     padding: const EdgeInsets.all(2.0),
                                     child: Icon(
                                      Icons.thumb_down_alt,
                                      size: 18,
                                      color: Theme.of(context).colorScheme.errorContainer,
                                                                   ),
                                   ),
                                 ),
                                 Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                    child: Text(
                                      "Unneccesary",
                                      style: TextStyle(
                                        fontFamily: "Gilmer",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color:
                                            Theme.of(context).colorScheme.onBackground,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ],
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
      ),
    );
  }
}
