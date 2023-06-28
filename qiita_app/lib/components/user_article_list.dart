// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:qiita_app/components/article_gesture_detector.dart';
import 'package:qiita_app/components/network_error.dart';
import 'package:qiita_app/models/article.model.dart';

class UserArticleList extends StatefulWidget {
  late Future<List<Article>> articles = Future.value([]);
  final ScrollController scrollController;
  UserArticleList({
    Key? key,
    required this.articles,
    required this.scrollController,
  }) : super(key: key);
  @override
  State<UserArticleList> createState() => _UserArticleListState();
}

class _UserArticleListState extends State<UserArticleList> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 400,
        child: FutureBuilder<List<Article>>(
          future: widget.articles,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                controller: widget.scrollController,
                itemCount: snapshot.data!.length + 1, // +1はローディングインジケーターのためのアイテム
                itemBuilder: (BuildContext context, int index) {
                  // childLoadingIndicatorがtrueで、かつindexが0の場合、ローディングインジケーターを表示
                  if (index < snapshot.data!.length) {
                    return ArticleGestureDetector(article: snapshot.data![index]);
                  }
                  else{
                    return const SizedBox();
                  }
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(
                  indent: 70.0,
                  height: 0.5,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Failed to load articles: ${snapshot.error}'));
            } else {
              return const NetworkError();
            }
          },
        ),
    );
  }
}
