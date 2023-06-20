import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qiita_app/components/search_app_bar.dart';
import 'package:qiita_app/models/article.model.dart';
import 'package:qiita_app/services/repository.dart';
import '../components/article_gesture_detector.dart';
import '../components/network_error.dart';
import '../components/no_match.dart';
//
class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  FeedPageState createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  bool showLoadingIndicator = false;
  late Future<List<Article>> articles;
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  String _searchWord = '';

  void _setArticles(List<Article> updatedArticles) {
    setState(() {
      articles = Future.value(updatedArticles);
    });
  }

  Future<void> _serchArticles(String search)async{
    _setLoading(true);
    setState(() {
      _searchWord=search;
      _currentPage = 1;
    });
    final results = await fetchArticle(_searchWord,_currentPage);
    _setArticles(results);
    _setLoading(false);
  }
  void _setLoading(bool value) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        showLoadingIndicator = value;
      });
    });
  }

  void _addScroll() {
    _setLoading(true);
    _currentPage++;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchArticle(_searchWord, _currentPage).then((value) {
        setState(() {
          articles = Future.value(value);
        });
        _setLoading(false);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _setLoading(true);
    articles = fetchArticle(_searchWord,_currentPage).then((value) {
      _setLoading(false);
      return value;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _addScroll();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        onArticlesChanged: _serchArticles,
      ),
      body: Center(
        child: FutureBuilder<List<Article>>(
          future: articles,
          builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
            if (showLoadingIndicator) {
              return const CircularProgressIndicator();
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const NoMatch();
            } else if (snapshot.hasData) {
              return RefreshIndicator(
                onRefresh: () async {
                  // リフレッシュ時の処理を実装するすればいいらしい。
                  await _serchArticles(_searchWord);
                },
                child: ListView.separated(
                  controller: _scrollController,
                  itemCount: snapshot.data!.length + 1, // +1はローディングインジケーターのためのアイテム
                  itemBuilder: (BuildContext context, int index) {
                      // childLoadingIndicatorがtrueで、かつindexが0の場合、ローディングインジケーターを表示
                    if (index < snapshot.data!.length) {
                      return ArticleGestureDetector(article: snapshot.data![index]);
                    } else {
                      // ローディングインジケーターを表示するウィジェットを返す
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider(
                    indent: 70.0,
                    height: 0.5,
                  ),
                ),
              );
            } else if (snapshot.hasError) {
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

