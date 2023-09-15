import 'package:flutter/material.dart';
import 'package:qiita_app/components/web_view_screen.dart';
import 'package:qiita_app/models/article.model.dart';

class ArticleGestureDetector extends StatefulWidget {
  const ArticleGestureDetector({
    super.key,
    required this.article,
    required this.onLoadingChanged,
  });

  final Article article;
  final Function(bool) onLoadingChanged;

  @override
  State<ArticleGestureDetector> createState() => _ArticleGestureDetectorState();
}

class _ArticleGestureDetectorState extends State<ArticleGestureDetector> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.onLoadingChanged(false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: WebViewScreen(
                url: widget.article.url,
                title:"Article" ,
              ),
            );
          },
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.article.user.iconUrl),
        ),
        title: Text(
          widget.article.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Text(
              '@${widget.article.user.id}投稿日:',
              style: const TextStyle(fontSize: 12.0),
              maxLines: 1, //テキストがオーバーフローしないように設定！
            ),
            Flexible(
              child: Text(
                widget.article.getFormattedDate(),
                style: const TextStyle(fontSize: 12.0),
                maxLines: 1,
              ),
            ),
            const Text(
              'いいね:',
              style: TextStyle(fontSize: 12.0),
              maxLines: 1,
            ),
            Flexible(
              child: Text(
                widget.article.likesCount.toString(),
                style: const TextStyle(fontSize: 12.0),
                overflow: TextOverflow.ellipsis, // テキストがオーバーフローした場合に省略記号で表示する設定
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}