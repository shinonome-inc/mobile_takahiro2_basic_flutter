import 'package:flutter/material.dart';
import 'package:qiita_app/models/article.model.dart';
import 'package:qiita_app/services/repository.dart';

class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(List<Article>) onArticlesChanged; // 追加

  const SearchBar({Key? key, required this.onArticlesChanged}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<SearchBar> createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  final _controller = TextEditingController();

  Future<void> _fetchArticles(String search) async {
      final results = await fetchArticle(search);
      widget.onArticlesChanged(results); // コールバック関数の呼び出し
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 142,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start, // 追加：要素を左寄せにする
        children: [
          const Text(
            "Feed",
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontFamily: 'Pacifico',
            ),
          ),
          const SizedBox(
            height: 19,
          ), // 不要な高さを削除
          SizedBox(
            height: 36,
            width: 343,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(fontSize: 17),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                  ),
                  onSubmitted: _fetchArticles,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ), // 不要な高さを削除
        ],
      ),

    );
  }
}
