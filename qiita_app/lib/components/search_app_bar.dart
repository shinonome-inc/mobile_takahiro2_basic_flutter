import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(String) onArticlesChanged;
  String searchWord;
  final TextEditingController _textEditingController = TextEditingController();

  SearchAppBar({
    Key? key,
    required this.onArticlesChanged,
    required this.searchWord,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 96,
      elevation: 0.0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: const Text(
        'Feed',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          fontFamily: 'Pacifico',
          color: Colors.black,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(36.0),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 19,
            bottom: 10,
          ),
          child: SizedBox(
            width: 343,
            height: 36,
            child: TextFormField(
              controller: _textEditingController,
              cursorColor: Colors.black,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                suffixIcon: IconButton(
                icon: const Icon(
                  Icons.clear,
                  color:Colors.grey,
                ),
                  onPressed: () {
                    _textEditingController.clear();
                  }
              ),
                filled: true,
                fillColor: const Color.fromRGBO(192, 192, 192, 0.12),
                prefixIcon: const Icon(
                    Icons.search,
                  color:Colors.grey,
                ),
                hintText: searchWord,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onFieldSubmitted: (search) => onArticlesChanged(search),
            ),
          ),
        ),
      ),
    );
  }
}
