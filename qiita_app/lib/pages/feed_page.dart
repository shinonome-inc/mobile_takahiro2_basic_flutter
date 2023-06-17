import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qiita_app/components/search_app_bar.dart';
import 'package:qiita_app/models/article.model.dart';
import 'package:qiita_app/services/repository.dart';
import '../components/article_gesture_detector.dart';
import '../components/network_error.dart';
import '../components/no_match.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  FeedPageState createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  bool showLoadingIndicator = false;
  late Future<List<Article>> articles;

  void _updateArticles(List<Article> updatedArticles) {
    setState(() {
      articles = Future.value(updatedArticles);
      showLoadingIndicator = false;
    });
  }

  void _getLoading() {
    setState(() {
      showLoadingIndicator = true; // ローディング表示フラグをtrueに設定
    });
  }

  void _setLoading(bool value) {
    setState(() {
      showLoadingIndicator = value;
    });
  }
  @override
  void initState() {
    super.initState();
    _setLoading(true);
    articles = fetchArticle('').then((value) {
      _setLoading(false);
      return value;
    });
  }


  @override
  Widget build(BuildContext context) {
          return Scaffold(
            appBar: SearchAppBar(
              onArticlesChanged: _updateArticles,
              onSearchStart: _getLoading,
            ),
            body: Center(
              child: FutureBuilder<List<Article>>(
                future: articles,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Article>> snapshot) {
                  if (showLoadingIndicator) {
                    return const CircularProgressIndicator();
                  }
                  else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const NoMatch();
                  }
                  else if (snapshot.hasData) {
                    return ListView.separated(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ArticleGestureDetector(article: snapshot.data![index]);
                      },
                      separatorBuilder: (BuildContext context, int index) => const Divider(
                        indent: 70.0,
                        height: 0.5,
                      ),
                    );
                  }
                  else if (snapshot.hasError) {
                    return Text(
                      "データの取得中にエラーが発生しました: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    );
                  } else {
                    return const NetworkError();
                  }
                },
              ),
            ),
          );
        }

    }

