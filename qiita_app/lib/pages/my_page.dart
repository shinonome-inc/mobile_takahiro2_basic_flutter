import 'package:flutter/material.dart';
import 'package:qiita_app/components/article_gesture_detector.dart';
import 'package:qiita_app/components/current_user_info.dart';
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
  late Future<List<Article>> articles;
  final int _currentPage = 1;
  String userId = "";
  final ScrollController _scrollController = ScrollController();
  bool showLoadingIndicator = false;

  @override
  void initState() {
    super.initState();
    _setLoading(true);
    articles = Future.value([]);
    _scrollController.addListener(_scrollListener);
    user = QiitaClient.fetchAuthenticatedUser().then((User value) {
      debugPrint(value.toString());
      setAuthUser(value);
      setAuthArticle();
      _setLoading(false);
      return value;
    });
  }



  void _setLoading(bool value) {
    setState(() {
      showLoadingIndicator = value;
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

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      //下までスクロールした時の記述を追加する
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(text: 'MyPage'),
      body: showLoadingIndicator
      ?const Center(child: CircularProgressIndicator())
      :RefreshIndicator(
        onRefresh: () async {
          // リフレッシュ時の処理を実装する.
        },
        child: ListView(
          children: [
            FutureBuilder<User>(
              future: user,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return CurrentUserInfo(user: snapshot.data);
                } else if (snapshot.hasError) {
                  return Center(child: Text('Failed to load user: ${snapshot.error}'));
                } else {
                  return const SizedBox();
                }
              },
            ),
            SizedBox(
              height: 561,
              child: FutureBuilder<List<Article>>(
                future: articles,
                builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Failed to load articles: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data != null) {
                    return ListView.separated(
                      controller: _scrollController,
                      itemCount: snapshot.data!.length + 1, // +1はローディングインジケーターのためのアイテム
                      itemBuilder: (BuildContext context, int index) {
                        if (index < snapshot.data!.length) {
                          return ArticleGestureDetector(article: snapshot.data![index]);
                        } else {
                          return const SizedBox();
                        }
                      },
                      separatorBuilder: (BuildContext context, int index) => const Divider(
                        indent: 70.0,
                        height: 0.5,
                      ),
                    );
                  }
                  else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }}
