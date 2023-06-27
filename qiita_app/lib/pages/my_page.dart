import 'package:flutter/material.dart';
import 'package:qiita_app/models/article.model.dart';
import 'package:qiita_app/services/repository.dart';
import '../components/article_gesture_detector.dart';
import '../components/default_app_bar.dart.dart';
import '../components/network_error.dart';
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
  String userId="";
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    QiitaClient.fetchAuthenticatedUser().then((User value) {
      debugPrint(value.toString());
      setAuthUser(value);
      setAuthArticle();
    },
    );
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
    articles = Future.value([]);
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
      appBar: const DefaultAppBar(text: 'MyPage',),
      body: FutureBuilder<User>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 24),
                    SizedBox(
                      height: 258,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(user.iconUrl),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                            ),
                          ),
                          Text(
                            user.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(user.id.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF828282),
                            ),),
                          Expanded(
                            flex: 1,
                            child: Container(
                            ),
                          ),
                          Container(
                            constraints: const BoxConstraints(
                              maxHeight: 99,
                              maxWidth: 327,
                            ),
                              child: Flexible(
                                child: Text(
                                  user.description,
                                  style: const TextStyle(fontSize: 12.0),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ),
                            ),
                          Expanded(
                            flex: 1,
                            child: Container(
                            ),
                          ),
                          Row(
                            children: [
                              Text('${user.followeesCount.toString()}フォロー中'),
                              const SizedBox(width: 16),
                              Text('${user.followersCount.toString()}フォロワー'),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: const Color(0xFFF2F2F2),
                            height: 28,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 13),
                              child: Text(
                                "記事投稿",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF828282),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                      SizedBox(
                        height: 400,
                        child: FutureBuilder<List<Article>>(
                          future: articles,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return RefreshIndicator(
                                onRefresh: () async {
                                  // リフレッシュ時の処理を実装する.
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
                              return Center(child: Text('Failed to load articles: ${snapshot.error}'));
                            } else {
                              return const NetworkError();
                            }
                          },
                        ),
                      ),
                  ],
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load user: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
