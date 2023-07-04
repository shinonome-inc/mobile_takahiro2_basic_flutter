import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:qiita_app/components/article_gesture_detector.dart';
import 'package:qiita_app/components/current_user_info.dart';
import 'package:qiita_app/components/network_error.dart';
import 'package:qiita_app/components/no_login.dart';
import 'package:qiita_app/components/no_refresh.dart';
import 'package:qiita_app/models/article.model.dart';
import 'package:qiita_app/services/repository.dart';
import '../components/default_app_bar.dart.dart';
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
  final ScrollController scrollController = ScrollController();
  bool hasBigIndicator = true;
  bool isNoLogin = false;
  bool isRefresh = false;
  double deviceHeight=0;
  bool hasNetError = false;
  final redirectWidget = const MyPage();

  @override
  void initState() {
    super.initState();
    subInitState();
  }

  Future<void> subInitState() async {
    await checkConnectivityStatus();
    checkUser();
    getDeviceHeight();
    if (isNoLogin) {
      _setLoading(false);
    } else {
      scrollController.addListener(_scrollListener);
      setAuthArticle();
      await articles;
    }
  }

  void refresh() {
    setState(() {
      isRefresh = true;
    });
  }

  void getDeviceHeight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        deviceHeight = MediaQuery.of(context).size.height;
      });
    });
  }

  Future<void> checkConnectivityStatus() async {
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

  void setNetError() {
    setState(() {
      hasNetError = true;
    });
  }

  void checkUser() {
    try {
      setState(() {
        user = Future.value(QiitaClient.fetchAuthenticatedUser());
      }); // ユーザー情報の取得を待機
    } catch (e) {
      setState(() {
        isNoLogin = true;
      });
    }
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

  void setAuthUser(User value) {
    setState(() {
      user = Future.value(value);
    });
  }

  Future<void> setAuthArticle() async {
    final resolvedUser = await user;
    if (resolvedUser != null) {
      setState(() {
        articles = QiitaClient.fetchAuthArticle(currentPage, resolvedUser.id);
      });
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> getRefresh() async {
    setState(() {
      user = QiitaClient.fetchAuthenticatedUser();
    });
    setAuthArticle();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      debugPrint("下までスクロールされました");
    }
  }

  Future<void> _reload() async {
    await QiitaClient.fetchAuthenticatedUser();
    final resolvedUser = await user;
    setState(() {
      currentPage= 1;
      userId=resolvedUser!.id;
    });
    await QiitaClient.fetchAuthenticatedUser();
    await QiitaClient.fetchAuthArticle(currentPage, userId);
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
                          } else if (userSnapshot.hasError) {
                            return Center(
                              child: Text(
                                  'Failed to load user: ${userSnapshot.error}'),
                            );
                          } else if (articlesSnapshot.hasError) {
                            return Center(
                              child: Text(
                                  'Failed to load articles: ${articlesSnapshot.error}'),
                            );
                          } else if (userSnapshot.hasData &&
                              userSnapshot.data != null &&
                              articlesSnapshot.hasData &&
                              articlesSnapshot.data != null) {
                            return RefreshIndicator(
                              color: Colors.grey,
                              onRefresh: ()async { refresh();},
                              child: ListView(
                                children: [
                                  if (userSnapshot.data != null)
                                    if (isRefresh)
                                      CurrentUserInfo(user: userSnapshot.data)
                                    else
                                      NoRefresh(user: userSnapshot.data),
                                  SizedBox(
                                    height: isRefresh
                                        ? deviceHeight - 498
                                        : deviceHeight - 448,
                                    child: ListView.separated(
                                      controller: scrollController,
                                      itemCount:
                                          articlesSnapshot.data!.length + 1,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (index <
                                            articlesSnapshot.data!.length) {
                                          return ArticleGestureDetector(
                                            article:
                                                articlesSnapshot.data![index],
                                            onLoadingChanged: _setLoading,
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              const Divider(
                                        indent: 70.0,
                                        height: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
}
