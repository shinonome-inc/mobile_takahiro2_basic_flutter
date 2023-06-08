import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class User {
  final String id;
  final String iconUrl;
  final String name;
  User({required this.id, required this.iconUrl,required this.name});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      iconUrl: json['profile_image_url'],
      name: json['name'] ?? '',
    );
  }
}

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
      createdAt: DateTime.parse(json['created_at'] ?? '0'),
      likesCount: json['likes_count'] ?? 0,
      user: User.fromJson(json['user']),
    );
  }
  String getFormattedDate() {
    final DateFormat formatter = DateFormat('yyyy/MM/dd');
    return formatter.format(createdAt);
  }
}

class QiitaClient {
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

class ArticleListView extends StatelessWidget {
  final List<Article> articles;
  const ArticleListView({required Key key, required this.articles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(1),
      itemCount: articles.length,
      itemBuilder: (BuildContext context, int index) {
        final article = articles[index];
        return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(article.user.iconUrl),
            ),
            title: Text(article.title),
          subtitle: Row(
            children: [
              Text(article.user.name != "" ? "@${article.user.name}" : '@無名なユーザ'),
              Text(article.getFormattedDate()),
              Text('いいね:${article.likesCount.toString()}'),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        indent: 70.0,
        color: Colors.grey,
      ),
    );
  }
}

class ArticleDetailPage extends StatelessWidget {
  final Article article;

  const ArticleDetailPage({required Key key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: Center(
        ),
      ),
    );
  }
}

class ArticleListPage extends StatefulWidget {
  const ArticleListPage({super.key});

  @override
  ArticleListPageState createState() => ArticleListPageState();
}

class ArticleListPageState extends State<ArticleListPage> {
  late Future<List<Article>> articles;

  @override
  void initState() {
    super.initState();
    articles = QiitaClient.fetchArticle();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Feeds',
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontFamily: 'Pacifico',
            ),
          ),
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),

        body: Center(
          child: FutureBuilder<List<Article>>(
            future: articles,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ArticleListView(
                  key: UniqueKey(),
                  articles: snapshot.data!,
                );
              } else if (snapshot.hasError) {
                return Text(
                  "データの取得中にエラーが発生しました: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}