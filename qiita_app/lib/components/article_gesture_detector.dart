import 'package:flutter/material.dart';
import 'package:qiita_app/models/article.model.dart';
import 'package:qiita_app/pages/my_page.dart';
import 'web_view.dart';
class ArticleGestureDetector extends StatelessWidget {
  const ArticleGestureDetector({
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