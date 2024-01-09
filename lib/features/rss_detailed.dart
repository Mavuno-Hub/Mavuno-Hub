import 'package:flutter/material.dart';

class RssInfoScreen extends StatelessWidget {
  final Map<String, String?> newsItem;

  RssInfoScreen(this.newsItem);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Details'),
      ),
         body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              // Display selected news card in half screen
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display image if available
                    if (newsItem['imageUrl'] != null)
                      Image.network(
                        newsItem['imageUrl']!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    SizedBox(height: 16),
                    Text(
                      newsItem['title'] ?? '',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      newsItem['description'] ?? '',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 16),
                    // Display more details of the news
                    // Add more Text widgets or other UI elements here for additional details
                    // Example:
                    // Text(
                    //   'Additional Information:',
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // SizedBox(height: 8),
                    // Text(
                    //   'Author: ${newsItem['author'] ?? 'Unknown'}',
                    //   style: TextStyle(fontSize: 16),
                    // ),
                    // Text(
                    //   'Published Date: ${newsItem['pubDate'] ?? 'Unknown'}',
                    //   style: TextStyle(fontSize: 16),
                    // ),
                    // Text(
                    //   'Category: ${newsItem['category'] ?? 'Unknown'}',
                    //   style: TextStyle(fontSize: 16),
                    // ),
                    // Add more details according to your news structure
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }}