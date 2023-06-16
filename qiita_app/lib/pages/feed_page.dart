import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qiita_app/components/search_app_bar.dart';
import 'package:qiita_app/models/article.model.dart';
import 'package:qiita_app/services/repository.dart';
import '../components/network_error.dart';
import '../components/no_match.dart';
import '../components/web_view.dart';
import 'package:flutter_offline/flutter_offline.dart';

class ArticleList extends StatelessWidget {
  final List<Article>? articles;
  const ArticleList({required Key key, required this.articles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: articles?.length?? 0,
      itemBuilder: (BuildContext context, int index) {
        final article = articles![index];
        if (index == articles!.length) {
          return const CircularProgressIndicator();
        } else {
          return ArticleListDetail(article: article);
        }
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        indent: 70.0,
        height: 0.5,
      ),
    );
  }
}

class ArticleListDetail extends StatelessWidget {
  const ArticleListDetail({
    super.key,
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
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
  }
}

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  FeedPageState createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  bool showLoadingIndicator = false;
  late Future<List<Article>> articles;


  void _updateArticles(List<Article> updatedArticles) {
    setState(() {
      articles = Future.value(updatedArticles);
      showLoadingIndicator = false;
    });
  }

  void _updateLoading() {
    setState(() {
      showLoadingIndicator = true; // ローディング表示フラグをtrueに設定
    });
  }

  @override
  void initState() {
    super.initState();
    articles = fetchArticle('');
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      child: const NetworkError(),
      connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
          ) {
        if (connectivity == ConnectivityResult.none) {
          // インターネットに接続されていない場合の処理
          return const NetworkError();
        } else {
          // インターネットに接続されている場合の処理
          return Scaffold(
            appBar: SearchAppBar(
              onArticlesChanged: _updateArticles,
              onSearchStart: _updateLoading,
            ),
            body: Center(
              child: FutureBuilder<List<Article>>(
                future: articles,
                builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) { // 修正: 引数の型をWidgetBuilderに変更
                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const NoMatch();
                  }
                  if (showLoadingIndicator) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    return ArticleList(
                      key: UniqueKey(),
                      articles: snapshot.data!,
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
      },
    );
  }

}
