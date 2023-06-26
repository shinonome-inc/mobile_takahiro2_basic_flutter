import 'dart:convert';
import 'package:qiita_app/models/article.model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../qiita_auth_key.dart';


class QiitaClient {
  static Map<String, String> authorizationRequestHeader = {};

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

  //アクセストークンを取得する。
  static Future<String?> fetchAccessToken(String redirectUrl) async {
    const String url = 'https://qiita.com/api/v2/access_tokens';
    final redirectUri = Uri.parse(redirectUrl);
    final queryParameters = redirectUri.queryParameters;
    final redirectUrlCode = queryParameters['code'];

    var response = await http.post(
      Uri.parse(url),
      headers: {'content-type': 'application/json'},
      body: json.encode({
        'client_id': QiitaAuthKey.clientId,
        'client_secret': QiitaAuthKey.clientSecret,
        'code': redirectUrlCode,
      }),
    );
    if (response.statusCode == 201) {
      final body = json.decode(response.body) as Map<String,
          dynamic>; //Json形式に変換
      final String accessToken = body["token"].toString();
      authorizationRequestHeader = {
        'Authorization': 'Bearer $accessToken',
      };
      return accessToken;
    }
    return null;
  }

  //アクセストークンをSharedPreferencesを使用することで、データを永続的に保存することができる。
  static Future<void> saveAccessToken(String accessToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('keyAccessToken', accessToken);
  }

  static Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('keyAccessToken');
  }

}