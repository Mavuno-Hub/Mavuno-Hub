import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mavunohub/cards/news_feed.dart';
import 'package:mavunohub/components/appbar.dart';
import 'package:mavunohub/logic/services/api_service.dart';
import 'package:mavunohub/models/news_model.dart';
import 'package:mavunohub/provider/news_provider.dart';
import 'package:mavunohub/styles/pallete.dart';
import 'package:mavunohub/user_controller.dart';

import '../../cards/news_card.dart'; // Make sure to import the relevant classes.

class News extends ConsumerWidget {
  // ignore: use_super_parameters
  News({Key? key}) : super(key: key);

  ApiService client = ApiService();
  // Create an instance of ApiService.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: const CustomAppBar(title: 'News'),
          body: SafeArea(
              child: FutureBuilder(
                  future: client.getArticles(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Article>> snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                        child: Text('Success'),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                    // return  ListView.builder(
                    //       itemCount: news.results!.length,
                    //       itemBuilder: (BuildContext context, int index) {
                    //         return NewsCard(article: news.results![index]);
                    //       }),
                  }))),
      //   body: FutureBuilder<List<Article>>( // Specify the type of data for FutureBuilder.
      //     future: client.getArticles(), // Use the client instance to call the method.
      //     builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return Center(child: CircularProgressIndicator());
      //       } else if (snapshot.hasData) {
      //         List<Article>? articles = snapshot.data; // Access the list of articles from snapshot.data.
      //         return ListView.builder(
      //           itemCount: articles?.length,
      //           itemBuilder: (context, index) {
      //             return ListTile(
      //               // title: Text(articles?[index].title),
      //             );
      //           },
      //         );
      //       } else if (snapshot.hasError) {
      //         return Text('Error: ${snapshot.error}');
      //       } else {
      //         return Center(child: CircularProgressIndicator());
      //       }
      //     },
      //   ),
    );
  }
}
