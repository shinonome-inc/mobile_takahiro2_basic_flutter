import 'dart:convert';
import 'package:qiita_app/models/article.model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../pages/qiita_auth_key.dart';
import 'package:flutter/material.dart';


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

//現在ログインしているユーザを表示する。List型ではないのに注意！
  static Future<User> fetchAuthenticatedUser() async {
    final accessToken = await getAccessToken();
    const url = 'https://qiita.com/api/v2/authenticated_user';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    debugPrint(response.body);
    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);
      User user = User.fromJson(jsonData as Map<String,
          dynamic>); //型チェック！Map<String, dynamic>かどうか判定する。
      return user;
    } else {
      throw Exception('Failed to load user');
    }
  }

  //ログアウト処理
  static Future<void> deleteAccessToken() async {
    final accessToken = await getAccessToken();
    String url = "https://qiita.com/api/v2/access_tokens/$accessToken";
    final response = await http.delete(Uri.parse(url));
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 204) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('keyAccessToken');
    } else {
      throw Exception('Failed to delete');
    }
  }
}