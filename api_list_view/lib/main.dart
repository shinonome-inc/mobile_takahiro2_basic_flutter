import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
void main() {
  fetchQiitaItems();
}

Future<void> fetchQiitaItems() async {
  var url = Uri.parse('https://qiita.com/api/v2/items');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    // リクエスト成功
    debugPrint(response.body);
  } else {
    // リクエスト失敗
    debugPrint('リクエストが失敗しました。ステータスコード: ${response.statusCode}');
  }
}