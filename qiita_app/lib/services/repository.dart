import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qiita_app/models/article.model.dart';
import 'package:http/http.dart' as http;
import 'package:qiita_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QiitaClient {
  static Map<String, String> authorizationRequestHeader = {};

  static Future<List<Article>> fetchArticle(String searchWord, int page) async {
    final response = await http.get(Uri.parse(
        'https://qiita.com/api/v2/items?page=$page&per_page=20&query=body:$searchWord'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonArray = json.decode(response.body);
      List<Article> articles =
          jsonArray.map((json) => Article.fromJson(json)).toList();
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
        'client_id': dotenv.env['clientId'],
        'client_secret': dotenv.env['6bd33756702ff37b1ac02b314d0e75063fc4a566'],
        'code': redirectUrlCode,
      }),
    );
    if (response.statusCode == 201) {
      final body =
          json.decode(response.body) as Map<String, dynamic>; //Json形式に変換
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

  static Future<List<Article>> fetchAuthArticle(int page, String userId) async {
    final accessToken = await getAccessToken();
    final url =
        'https://qiita.com/api/v2/items?page=$page&per_page=20&query=user:$userId';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<Article> articles =
          jsonData.map((dynamic item) => Article.fromJson(item)).toList();
      return articles;
    } else {
      throw Exception('Failed to load articles');
    }
  }

  static Future<User> fetchAuthenticatedUser() async {
    final accessToken = await getAccessToken();
    const url = 'https://qiita.com/api/v2/authenticated_user';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);
      User user = User.fromJson(jsonData
          as Map<String, dynamic>); //型チェック！Map<String, dynamic>かどうか判定する。
      return user;
    } else {
      throw Exception('Failed to load user');
    }
  }
}
