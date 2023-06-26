import 'package:flutter/material.dart';

class NoMatch extends StatelessWidget {
  const NoMatch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, // 全体の背景色を白に設定
      body: Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(),
        ),
        const Text(
          "検索にマッチする記事はありませんでした",
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
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            letterSpacing: 1.2,
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
      ],
    ),
    );
  }
}