import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qiita_app/components/SearchBar.dart';
import 'package:qiita_app/models/article.model.dart';
import 'package:qiita_app/services/repository.dart';
import '../components/web_view.dart';

class ArticleList extends StatelessWidget {
  final List<Article>? articles;
  const ArticleList({required Key key, required this.articles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: articles?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        final article = articles![index];
        return GestureDetector(
          onTap: () {
            showModalBottomSheet<void>(
              context: context,
              useRootNavigator: true,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,

              builder: (BuildContext context) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: WebView(
                    url: article.url,
                  ),
                );
              },
            );
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(article.user.iconUrl),
            ),
            title: Text(article.title,
                maxLines:2,
            ),
            subtitle: Row(
              children: [
                Flexible(
                  child: Text(
                    '@${article.user.id}',
                    style: const TextStyle(fontSize: 12.0), // 適切なフォントサイズを指定してください
                    overflow: TextOverflow.ellipsis, // テキストがオーバーフローした場合に省略記号で表示する設定
                  ),
                ),
                Flexible(
                  child: Text(
                    article.getFormattedDate(),
                    style: const TextStyle(fontSize: 12.0), // 適切なフォントサイズを指定してください
                    overflow: TextOverflow.ellipsis, // テキストがオーバーフローした場合に省略記号で表示する設定
                  ),
                ),
                Flexible(
                  child: Text(
                    'いいね:${article.likesCount.toString()}',
                    style: const TextStyle(fontSize: 12.0), // 適切なフォントサイズを指定してください
                    overflow: TextOverflow.ellipsis, // テキストがオーバーフローした場合に省略記号で表示する設定
                  ),
                ),
              ],
            ),

          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        indent: 70.0,
        height: 0.5,
      ),
    );
  }
}

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  FeedPageState createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  late Future<List<Article>> articles;

  @override
  void initState() {
    super.initState();
    articles = fetchArticle('Flutter');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: SearchBar()
        ),
        body: Center(
          child: FutureBuilder<List<Article>>(
            future: articles,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ArticleList(
                  key: UniqueKey(),
                  articles: snapshot.data,
                );
              } else if (snapshot.hasError) {
                return Text(
                  "データの取得中にエラーが発生しました: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
    );
  }
}
