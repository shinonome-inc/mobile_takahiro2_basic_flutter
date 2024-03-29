import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:qiita_app/components/article_gesture_detector.dart';
import 'package:qiita_app/components/network_error.dart';
import 'package:qiita_app/components/no_login.dart';
import 'package:qiita_app/components/user_info.dart';
import 'package:qiita_app/models/article.model.dart';
import 'package:qiita_app/services/repository.dart';

import '../components/default_app_bar.dart';
import '../models/user_model.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Future<User>? user;
  Future<List<Article>> articles = Future.value([]);
  int currentPage = 1;
  String userId = "";
  bool hasBigIndicator = true;
  bool isNoLogin = false;
  bool isRefresh = false;
  double deviceHeight = 0;
  bool hasNetError = false;
  final redirectWidget = const MyPage();
  Future<String>? accessToken;

  @override
  void initState() {
    super.initState();
    checkConnectivityStatus();
    checkAccessToken();
    getDeviceHeight();
  }

  Future<void> checkAccessToken() async {
    String? token = await QiitaClient.getAccessToken();
    if (token == null) {
      setState(() {
        isNoLogin = true;
        _setLoading(false);
      });
    } else {
      setState(() {
        accessToken = Future.value(token);
        user = QiitaClient.fetchAuthenticatedUser();
      });
      final resolvedUser = await user;
      setState(() {
        articles = QiitaClient.fetchAuthArticle(currentPage, resolvedUser!.id);
      });
    }
  }

  void getDeviceHeight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        deviceHeight = MediaQuery.of(context).size.height;
      });
    });
  }

  Future<void> checkConnectivityStatus() async {
    debugPrint("ネットに接続チェック");
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      //ネットワークに接続されていない時
      setNetError(true);
      _setLoading(false);
    } else {
      //ネットに接続されている時
      debugPrint("ネットに接続");
      setNetError(false);
    }
  }

  void setNetError(bool error) {
    setState(() {
      hasNetError = error;
    });
  }

  void setNoLogin() {
    setState(() {
      isNoLogin = true;
    });
  }

  void _setLoading(bool value) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        hasBigIndicator = value;
      });
    });
  }

  Future<void> getRefresh() async {
    final resolvedUser = await user;
    setState(() {
      user = QiitaClient.fetchAuthenticatedUser();
      articles = QiitaClient.fetchAuthArticle(currentPage, resolvedUser!.id);
    });
  }

  Future<void> _reload() async {
    await checkConnectivityStatus();
    if (!isNoLogin) {
      debugPrint("ログインしています");
      QiitaClient.fetchAuthenticatedUser();
      setState(() {
        user = QiitaClient.fetchAuthenticatedUser();
      });
      final resolvedUser = await user;
      setState(() {
        articles = QiitaClient.fetchAuthArticle(currentPage, resolvedUser!.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hasNetError
          ? const DefaultAppBar(text: '') as PreferredSizeWidget?
          : const DefaultAppBar(text: 'MyPage'),
      body: hasNetError
          ? NetworkError(onTapReload: _reload)
          : isNoLogin
              ? const NoLogin()
              : Center(
                  child: FutureBuilder<User>(
                    future: user,
                    builder: (context, userSnapshot) {
                      return FutureBuilder<List<Article>>(
                        future: articles,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Article>> articlesSnapshot) {
                          if (userSnapshot.connectionState ==
                                  ConnectionState.waiting ||
                              articlesSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                                color: Colors.grey);
                          } else if (userSnapshot.hasError ||
                              articlesSnapshot.hasError) {
                            return Center(
                              child: Text(
                                  'Failed to load user: ${userSnapshot.error}${articlesSnapshot.error}'),
                            );
                          } else if (userSnapshot.hasData &&
                              userSnapshot.data != null &&
                              articlesSnapshot.hasData &&
                              articlesSnapshot.data != null) {
                            return LayoutBuilder(
                              builder: (context, constraints) {
                                double myPageHeight = constraints.maxHeight;
                                return RefreshIndicator(
                                  color: Colors.grey,
                                  onRefresh: () async {
                                    _reload();
                                  },
                                  child: ListView(
                                    children: [
                                      UserInfo(user: userSnapshot.data),
                                      articleInfo(
                                          articlesSnapshot, myPageHeight),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      );
                    },
                  ),
                ),
    );
  }

  Column articleInfo(AsyncSnapshot<List<Article>> articlesSnapshot, double h) {
    return Column(
      children: [
        SizedBox(
          height: h - 251,
          child: ListView.separated(
            itemCount: articlesSnapshot.data!.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index < articlesSnapshot.data!.length) {
                debugPrint(articles.toString());
                return ArticleGestureDetector(
                  article: articlesSnapshot.data![index],
                  onLoadingChanged: _setLoading,
                );
              } else {
                return const SizedBox();
              }
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
              indent: 70.0,
              height: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}
