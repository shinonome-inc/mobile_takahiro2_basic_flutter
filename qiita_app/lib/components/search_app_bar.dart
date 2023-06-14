import 'package:flutter/material.dart';
import 'package:qiita_app/models/article.model.dart';
import 'package:qiita_app/services/repository.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(List<Article>) onArticlesChanged; // 追加

  const SearchAppBar({Key? key, required this.onArticlesChanged}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 60);

  @override
  State<SearchAppBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchAppBar> {
  Future<void> _fetchArticles(String search) async {
      final results = await fetchArticle(search);
      widget.onArticlesChanged(results); // コールバック関数の呼び出し
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Feed',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          fontFamily: 'Pacifico',
          color: Colors.black,
        ),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(36.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SizedBox(
            width: 343,
            height: 36,
            child: TextFormField(
              cursorColor: Colors.black,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                filled: true,
                fillColor: const Color.fromRGBO(192, 192, 192, 0.12),
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onFieldSubmitted: _fetchArticles,
            ),
          ),
        ),
      ),


    );
  }
}
