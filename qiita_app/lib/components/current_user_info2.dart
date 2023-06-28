import 'package:flutter/material.dart';
import 'package:qiita_app/components/user_article_list.dart';
import 'package:qiita_app/models/user_model.dart';

class CurrentUserInfo extends StatelessWidget {
  late Future<List<Article>> articles = Future.value([]);
  CurrentUserInfo({Key? key,required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: user,
      builder: (context, snapshot) {
        final user = snapshot.data!;
        if (snapshot.hasData) {
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
                  UserArticleList(articles: articles, scrollController: _scrollController),
                ],
              )
            ],
          );
        }
        else if (snapshot.hasError) {
          return Center(child: Text('Failed to load user: ${snapshot.error}'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }
  }
}
