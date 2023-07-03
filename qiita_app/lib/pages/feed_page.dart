import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
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
  bool showLoadingIndicator = true;
  bool childLoadingIndicator = false;
  late Future<List<Article>> articles = Future.value([]);
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  String _searchWord = '';
  bool netError = false;

  void _setArticles(List<Article> updatedArticles) {
    setState(() {
      articles = Future.value(updatedArticles);
    });
  }

  Future<void> _searchArticle(String search) async {
    _setChildLoading(true);
    setState(() {
      _searchWord = search;
      _currentPage = 1;
    });
    final results = await QiitaClient.fetchArticle(_searchWord, _currentPage);
    _setArticles(results);
    _setChildLoading(false);
  }

  void _setLoading(bool value) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        showLoadingIndicator = value;
      });
    });
  }

  void _setChildLoading(bool value) {
    if (mounted) {
      // mountedプロパティのチェック
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          childLoadingIndicator = value;
        });
      });
    }
  }

  void _addScroll() {
    if (mounted) {
      // mountedプロパティのチェック
      _setChildLoading(true);
      _currentPage++;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        QiitaClient.fetchArticle(_searchWord, _currentPage).then((newArticles) {
          if (mounted) {
            // mountedプロパティのチェック
            setState(() {
              articles = articles.then(
                      (existingArticles) => [...existingArticles, ...newArticles]);
            });
            _setChildLoading(false);
          }
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkConnectivityStatus();
    getArticle();
    _scrollController.addListener(_scrollListener);
    _setLoading(false);
  }

  void getArticle()async{
    setState(() {
      articles = QiitaClient.fetchArticle(_searchWord, _currentPage);
    });
    await articles;
  }

  void checkConnectivityStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      debugPrint('インターネットに接続されていません');
      setNetError();
      _setLoading(false);
    } else if (connectivityResult == ConnectivityResult.mobile) {
      debugPrint('モバイルデータで接続されています');
    } else if (connectivityResult == ConnectivityResult.wifi) {
      debugPrint('Wi-Fiで接続されています');
    }
  }

  void setNetError(){
    setState(() {
      netError=true;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _addScroll();
      debugPrint("下までスクロールされました");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: SearchAppBar(
          onArticlesChanged: _searchArticle,
        ),
        body: showLoadingIndicator
            ? const Center(child: CircularProgressIndicator(color: Colors.grey,))
            : netError
            ?const NetworkError()
            : Center(
          child: FutureBuilder<List<Article>>(
            future: articles,
            builder:
                (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting){//late article をnullに設定したので、ConnectionState.waitingを追加しました。
                return const Center(child: CircularProgressIndicator(color: Colors.red,));
              }
              else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const NoMatch();
              } else if (snapshot.hasData) {
                return RefreshIndicator(
                  color: Colors.grey,
                  onRefresh: () async {
                    // リフレッシュ時の処理を実装する.
                    await _searchArticle(_searchWord);
                  },
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: snapshot.data!.length + 1,
                    // +1はローディングインジケーターのためのアイテム
                    itemBuilder: (BuildContext context, int index) {
                      // childLoadingIndicatorがtrueで、かつindexが0の場合、ローディングインジケーターを表示
                      if (index < snapshot.data!.length) {
                        return ArticleGestureDetector(
                            article: snapshot.data![index],
                            onLoadingChanged: _setLoading);
                      } else if (childLoadingIndicator) {
                        // ローディングインジケーターを表示するウィジェットを返す
                        return const Center(
                            child: CupertinoActivityIndicator(
                              radius: 20.0,
                              color: CupertinoColors.inactiveGray,
                            ));
                      }
                      return null;
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
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
                return const Text('不明なエラーが発生しました。運営までお問い合わせください');
              }
            },
          ),
        ),
      ),
    );
  }
}