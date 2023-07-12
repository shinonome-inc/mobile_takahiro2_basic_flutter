import 'package:flutter/material.dart';
// ignore: must_be_immutable
class NoMatch extends StatelessWidget{
  Function(String) onArticlesRefresh;
  NoMatch({Key? key,required this.onArticlesRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.grey,
      onRefresh: () async {
        onArticlesRefresh("");
      },
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          const Text(
            "検索にマッチする記事はありませんでした",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontFamily: "Noto Sans JP",
            ),
          ),
          const SizedBox(
            height: 17,
          ),
          const Text(
            "条件を変えるなどして再度検索してください",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}