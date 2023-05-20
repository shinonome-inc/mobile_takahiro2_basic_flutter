import 'package:http/http.dart' as http;

void main() {
  fetchQiitaItems();
}

Future<void> fetchQiitaItems() async {
  var url = Uri.parse('https://qiita.com/api/v2/items');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    // リクエスト成功
    print(response.body);
  } else {
    // リクエスト失敗
    print('リクエストが失敗しました。ステータスコード: ${response.statusCode}');
  }
}
