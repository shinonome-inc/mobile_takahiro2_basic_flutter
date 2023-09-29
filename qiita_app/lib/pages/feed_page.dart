import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qiita_app/components/default_app_bar.dart';
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
  bool hasBigIndicator = false;
  bool hasSmallIndicator = false;
  Future<List<Article>>? articles;
  final ScrollController scrollController = ScrollController();
  int currentPage = 1;
  String searchWord = 'Search';
  bool hasNetError = false;
  final redirectWidget = const FeedPage();
  FocusNode focusNode = FocusNode();
  bool hasRequest = false;
  TextEditingController textEditingController = TextEditingController();

  void _setArticles(List<Article> updatedArticles) {
    setState(() {
      articles = Future.value(updatedArticles);
    });
  }

  Future<void> _searchArticle(String search) async {
    _setChildLoading(true);
    setState(() {
      searchWord = search;
      currentPage = 1;
    });
    final results = await QiitaClient.fetchArticle(searchWord, currentPage);
    _setArticles(results);
    _setChildLoading(false);
  }

  void _setLoading(bool value) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        hasBigIndicator = value;
      });
    });
  }

  void _setChildLoading(bool value) {
    if (mounted) {
      // mountedプロパティのチェック
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          hasSmallIndicator = value;
        });
      });
    }
  }

  Future<void> _addScroll() async {
    if (mounted) {
      // mountedプロパティのチェック
      _setChildLoading(true);
      currentPage++;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          final newArticles =
              await QiitaClient.fetchArticle(searchWord, currentPage);
          setState(() {
            articles = articles?.then(
                (existingArticles) => [...existingArticles, ...newArticles]);
          });
        } catch (e) {
          setState(() {
            hasRequest = true;
          });
        }
        _setChildLoading(false);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkConnectivityStatus();
    hasBigIndicator = true;
    getArticle().then((_) {
      hasBigIndicator = false;
    });
    scrollController.addListener(_scrollListener);
  }

  Future<void> getArticle() async {
    setState(() {
      articles = Future.value(QiitaClient.fetchArticle("", currentPage));
    });
  }

  Future<void> checkConnectivityStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    // ignore: unrelated_type_equality_checks
    if (connectivityResult == ConnectivityResult.none) {
      debugPrint("ネットに接続失敗");
      setNetError(true);
      _setLoading(false);
    } else {
      //ネットに接続されている時
      debugPrint("ネットに接続");
      setNetError(false);
      _setLoading(false);
    }
  }

  void setNetError(bool error) {
    setState(() {
      hasNetError = error;
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      await _addScroll();
    }
  }

  Future<void> _reload() async {
    debugPrint("リロードが実行されました");
    await checkConnectivityStatus();
    setState(() {
      articles = QiitaClient.fetchArticle(searchWord, currentPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: _buildFutureBuilder(),
    );
  }

  Widget _buildFutureBuilder() {
    return Scaffold(
      appBar: hasNetError
          ? const DefaultAppBar(text: '') as PreferredSizeWidget?
          : SearchAppBar(
              onArticlesChanged: _searchArticle,
              searchWord: searchWord,
              textEditingController: textEditingController),
      body: FutureBuilder<List<Article>>(
        future: articles,
        builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.grey,
            ));
          } else if (snapshot.hasError || hasNetError) {
            return NetworkError(onTapReload: _reload);
          } else {
            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!.isEmpty) {
              return NoMatch(onArticlesRefresh: _searchArticle);
            }
            return _buildRefreshIndicator(snapshot);
          }
        },
      ),
    );
  }

  Widget _buildRefreshIndicator(AsyncSnapshot<List<Article>> snapshot) {
    return RefreshIndicator(
      color: Colors.grey,
      onRefresh: () async {
        await _reload();
      },
      child: ListView.separated(
        controller: scrollController,
        itemCount: snapshot.data!.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index < snapshot.data!.length) {
            return ArticleGestureDetector(
              article: snapshot.data![index],
              onLoadingChanged: _setLoading,
            );
          } else if (hasSmallIndicator) {
            return const Center(
              child: CupertinoActivityIndicator(
                radius: 20.0,
                color: CupertinoColors.inactiveGray,
              ),
            );
          }
          return null;
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
          indent: 70.0,
          height: 0.5,
        ),
      ),
    );
  }
}
