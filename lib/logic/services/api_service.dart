import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mavunohub/models/news_model.dart';

class ApiService {
  final String endPointUrl =
   "https://newsapi.ai/api/v1/article/getArticles?"
      "query=%7B%22%24query%22%3A%7B%22%24and%22%3A%5B%7B%22categoryUri%22%3A%22dmoz%2F"
      "Business%2FAgriculture_and_Forestry%2FLivestock%22%7D%2C%7B%22lang%22%3A%22eng%22%7D%5D%7D%2C"
      "%22%24filter%22%3A%7B%22forceMaxDataTimeWindow%22%3A%2231%22%7D%7D&"
      "resultType=articles&articlesSortBy=date&includeArticleImage=true&"
      "apiKey=0a5b2d98-984a-4aad-995a-9a5f29a79de0&callback=JSON_CALLBACK";
  // Remove unexpected characters from JSON data
  String _cleanJson(String json) {
    final cleanedJson = json.replaceAll(RegExp(r'[^\x20-\x7E\t\n\r\f]'), '');
    return cleanedJson;
  }

  Future<List<Article>> getArticles() async {
    final response = await http.get(Uri.parse(endPointUrl));

    if (response.statusCode == 200) {
      final jsonpData = response.body;

      // Clean up the JSON response by removing unexpected characters
      final cleanedJsonData = _cleanJson(jsonpData);

      try {
        final jsonData = json.decode(cleanedJsonData);

        if (jsonData != null) {
          final articlesData = jsonData['articles'];

          if (articlesData is List) {
            final List<Article> articles = articlesData
                .map((dynamic item) =>
                    Article.fromJson(item as Map<String, dynamic>))
                .toList();
            return articles;
          } else {
            throw Exception("Invalid 'articles' structure in JSON response");
          } 
        } else {
          throw Exception("Failed to extract and parse JSON data");
        }
      } catch (e) {
        throw Exception("Failed to parse JSON: $e");
      }
    } else {
      throw Exception("Failed to fetch news");
    }
  }
}


class ApiUrls {
  static String baseUrl =
      "https://newsdata.io/api/1/news?apikey=pub_326556128337024983f3616b4e2320a2cc3d5&q=Agriculture%20in%20Kenya";
  }