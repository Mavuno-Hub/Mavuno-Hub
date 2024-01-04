import 'package:flutter/material.dart';
import 'package:mavunohub/components/snacky.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class News extends StatefulWidget {
  @override
  NewsState createState() => NewsState();
}

class NewsState extends State<News> {
  late RssFeed _feed = RssFeed(items: []);

  Future<void> loadFeed() async {
       SnackBarHelper snacky = SnackBarHelper(context);
    try {
      final String FEED_URL = 'https://kilimonews.co.ke/agribusiness/feed/';
      final client = http.Client();
      final response = await client.get(Uri.parse(FEED_URL));
      final xmlString = response.body;
      final channel = RssFeed.parse(xmlString);
      setState(() {
        _feed = channel;
      });
    } catch (e) {
      print('Error loading RSS feed: $e');
       snacky.showSnackBar("An error occurred: $e", isError: true);

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
        title: Text('Kenyan Agriculture News'),
      ),
      body: _feed.items!.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _feed.items?.length,
              itemBuilder: (context, index) {
                final item = _feed.items?[index];
                return ListTile(
                  title: Text(item?.title ?? ''),
                //  subtitle: Text(item?.pubDate ?? ''),
                  onTap: () {
                    if (item?.link != null) {
                      launch(item!.link!);
                    }
                  },
                );
              },  
            ),
    );
  }
}
