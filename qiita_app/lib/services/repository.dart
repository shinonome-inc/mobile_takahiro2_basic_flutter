import 'dart:convert';
import 'package:qiita_app/models/article.model.dart';
import 'package:http/http.dart' as http;class QiitaClient {
  static Future<List<Article>> fetchArticle() async {
    final response = await http.get(Uri.parse('https://qiita.com/api/v2/items'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonArray = json.decode(response.body);
      return jsonArray.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load article');
    }
  }
}