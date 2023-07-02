import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qiita_app/components/article_gesture_detector.dart';
import 'package:qiita_app/components/current_user_info.dart';
import 'package:qiita_app/components/no_login.dart';
import 'package:qiita_app/components/no_refresh.dart';
import 'package:qiita_app/models/article.model.dart';
import 'package:qiita_app/services/repository.dart';
import '../components/default_app_bar.dart.dart';
import '../models/user_model.dart';

class MyPage2 extends StatefulWidget {
  const MyPage2({Key? key}) : super(key: key);

  @override
  State<MyPage2> createState() => _MyPage2State();
}

class _MyPage2State extends State<MyPage2> {
  late double myPageHeight;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(text: 'MyPage'),
      body: Container(
        color: Colors.grey,
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double myPageHeight = constraints.maxHeight;
                  return Container(
                    color: Colors.blue,
                    child: Column(
                      children: [
                        FutureBuilder<User>(
                          future: user,
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              if (onRefresh) {
                                return CurrentUserInfo(user: snapshot.data);
                              }
                              return NoRefresh(user: snapshot.data);
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text(
                                      'Failed to load user: ${snapshot.error}'));
                            } else {
                              return const SizedBox();
                            }
                          },
                        )
                        SizedBox(
                          height: onRefresh
                              ? myPageHeight - 498
                              : myPageHeight - 448,
                          child: FutureBuilder<List<Article>>(
                            future: articles,
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Article>> snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text(
                                        'Failed to load articles: ${snapshot.error}'));
                              } else if (snapshot.hasData &&
                                  snapshot.data != null) {
                                return ListView.separated(
                                  controller: _scrollController,
                                  itemCount: snapshot.data!.length + 1,
                                  itemBuilder: (BuildContext context, int index) {
                                    if (index < snapshot.data!.length) {
                                      return ArticleGestureDetector(
                                          article: snapshot.data![index],
                                          onLoadingChanged: _setLoading);
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
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
