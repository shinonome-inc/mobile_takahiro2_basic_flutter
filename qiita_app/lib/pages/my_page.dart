import 'package:flutter/material.dart';
import 'package:qiita_app/components/current_user_info.dart';
import 'package:qiita_app/components/user_article_list.dart';
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
      body:  Column(
        children: [
          CurrentUserInfo(user: user),
          UserArticleList(articles: articles, scrollController: _scrollController),
        ],
      ),
    );
  }
}
