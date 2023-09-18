import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qiita_app/components/default_app_bar.dart';
import 'package:qiita_app/components/error_request.dart';
import 'package:qiita_app/components/search_app_bar.dart';
import 'package:qiita_app/models/article.model.dart';
import 'package:qiita_app/services/repository.dart';
import '../components/article_gesture_detector.dart';
import '../components/network_error.dart';
import '../components/no_match.dart';


final searchWordProvider = StateProvider((ref) => '');
class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  FeedPageState createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  bool hasBigIndicator = true;
  bool hasSmallIndicator = false;
  late Future<List<Article>> articles = Future.value([]);
  final ScrollController scrollController = ScrollController();
  int currentPage = 1;
  String searchWord = 'Search';
  bool hasNetError = false;
  final redirectWidget =const FeedPage();
  FocusNode focusNode = FocusNode();
  bool hasRequest = false;

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

  void _addScroll() {
    if (mounted) {
      // mountedプロパティのチェック
      _setChildLoading(true);
      currentPage++;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          final newArticles = await QiitaClient.fetchArticle(searchWord, currentPage);
          setState(() {
            articles = articles.then(
                    (existingArticles) => [...existingArticles, ...newArticles]);
          });
        } catch (e) {
          setState(() {
            hasRequest=true;
          });
        }
        _setChildLoading(false);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    subInitState();
  }

  Future<void> subInitState()async{
    checkConnectivityStatus();
    await getArticle();
    scrollController.addListener(_scrollListener);
    _setLoading(false);
  }

  Future<void> getArticle()async{
    setState(() {
      articles = QiitaClient.fetchArticle(searchWord, currentPage);
    });
  }

  Future<void> checkConnectivityStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setNetError();
      _setLoading(false);
    }
  }

  void setNetError(){
    setState(() {
      hasNetError=true;
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      _addScroll();
    }
    if (scrollController.position.pixels > 0) {
      FocusScope.of(context).unfocus();
    }
  }
  void setLoading(){
    setState(() {
    });
  }
  void _reload() async {
    setState(() {
      hasNetError=false;
      articles =QiitaClient.fetchArticle(searchWord, currentPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }
  _buildAppBar() {
    return hasNetError
        ? const DefaultAppBar(text: '')
        : SearchAppBar(onArticlesChanged: _searchArticle,searchWord: searchWord);
  }

  Widget _buildBody() {
    if (hasBigIndicator) {
      return const Center(child: CircularProgressIndicator(color: Colors.grey,));
    } else if (hasNetError) {
      return NetworkError(onTapReload: _reload);
    } else if (hasRequest) {
      return ErrorRequest(onArticlesRefresh: _searchArticle);
    } else {
      return _buildFutureBuilder();
    }
  }

  Widget _buildFutureBuilder() {
    return Center(
      child: FutureBuilder<List<Article>>(
        future: articles,
        builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return NoMatch(onArticlesRefresh: _searchArticle);
          } else if (snapshot.hasData) {
            return _buildRefreshIndicator(snapshot);
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
    );
  }

  Widget _buildRefreshIndicator(AsyncSnapshot<List<Article>> snapshot) {
    return RefreshIndicator(
      color: Colors.grey,
      onRefresh: () async {
        await _searchArticle(searchWord);
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


