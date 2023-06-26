import 'package:qiita_app/models/user_model.dart';
import 'package:intl/intl.dart';
class Article {
  final String title;
  final String url;
  final User user;
  final DateTime createdAt;
  final int likesCount;

  Article({required this.title, required this.url, required this.user, required this.createdAt,required this.likesCount});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      url: json['url'],
      createdAt: DateTime.parse(json['created_at']),
      likesCount: json['likes_count'],
      user: User.fromJson(json['user']),
    );
  }
  String getFormattedDate() {
    final DateFormat formatter = DateFormat('yyyy/MM/dd');
    return formatter.format(createdAt);
  }
}
