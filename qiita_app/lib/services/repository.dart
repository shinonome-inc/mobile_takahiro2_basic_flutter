import 'dart:convert';
import 'package:qiita_app/models/article.model.dart';
import 'package:http/http.dart' as http;

class QiitaClient {
  static Future<List<Article>> fetchArticle(String searchWord, int page) async {
    final response = await http.get(Uri.parse(
        'https://qiita.com/api/v2/items?page=$page&per_page=20&query=body:$searchWord'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonArray = json.decode(response.body);
      List<Article> articles = jsonArray.map((json) => Article.fromJson(json))
          .toList();
      return articles;
    } else {
      throw Exception('Failed to load articles');
    }
  }
}


