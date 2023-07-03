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
  late Future<List<Article>> articles = Future.value([]);
  final int _currentPage = 1;
  String userId = "";
  final ScrollController _scrollController = ScrollController();
  bool showLoadingIndicator = true;
  bool noLoginUser = false;
  bool onRefresh = false;
  late double deviceHeight;
  bool netError = false;

  @override
  void initState() {
    super.initState();
    subInitState();

  }

  void subInitState() async {
    checkConnectivityStatus();
    checkUser();
    getDeviceHeight();
    if (noLoginUser) {
      _setLoading(false);
    } else {
      _scrollController.addListener(_scrollListener);
      setAuthArticle();
      await articles;
      _setLoading(false);
    }
  }

  void refresh() {
    setState(() {
      onRefresh = true;
    });
  }

  void getDeviceHeight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        deviceHeight = MediaQuery.of(context).size.height;
      });
    });

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



  void checkUser() async {
    try {
      setState(() {
        user = Future.value(QiitaClient.fetchAuthenticatedUser());
      });
      await user; // ユーザー情報の取得を待機
    } catch (e) {
      setState(() {
        noLoginUser = true;
      });
    }
  }

  void setNoLogin() {
    setState(() {
      noLoginUser = true;
    });
  }

  void _setLoading(bool value) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        showLoadingIndicator = value;
      });
    });
  }

  void setAuthUser(User value) {
    setState(() {
      user = Future.value(value);
    });
  }

  void setAuthArticle() async {
    final resolvedUser = await user;
    if (resolvedUser != null) {
      setState(() {
        articles = QiitaClient.fetchAuthArticle(_currentPage, resolvedUser.id);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  getRefresh() async {
    setState(() {
      user = QiitaClient.fetchAuthenticatedUser();
    });
    setAuthArticle();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      debugPrint("下までスクロールされました");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(text: 'MyPage'),
      body: showLoadingIndicator
          ? const Center(child: CircularProgressIndicator(color: Colors.grey,))
          : netError
          ? const NetworkError()
          : noLoginUser
          ? const NoLogin()
          : ListView(
        children: [
          Center(
            child: FutureBuilder<User>(
              future: user,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(color: Colors.red);
                } else if (snapshot.hasData && snapshot.data != null) {
                  if (onRefresh) {
                    return CurrentUserInfo(user: snapshot.data);
                  }
                  return NoRefresh(user: snapshot.data);
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Failed to load user: ${snapshot.error}')
                  );
                } else {
                  return const NetworkError();
                }
              },
            ),
          ),
          SizedBox(
            height: onRefresh ? deviceHeight - 498 : deviceHeight - 448,
            child: FutureBuilder<List<Article>>(
              future: articles,
              builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Failed to load articles: ${snapshot.error}')
                  );
                } else if (snapshot.hasData && snapshot.data != null) {
                  return ListView.separated(
                    controller: _scrollController,
                    itemCount: snapshot.data!.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < snapshot.data!.length) {
                        return ArticleGestureDetector(
                            article: snapshot.data![index],
                            onLoadingChanged: _setLoading
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                    separatorBuilder: (BuildContext context, int index) => const Divider(
                      indent: 70.0,
                      height: 0.5,
                    ),
                  );
                } else {
                  return const NetworkError();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

}
