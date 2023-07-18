import 'package:flutter/material.dart';
// ignore: must_be_immutable
class ErrorRequest extends StatelessWidget{
  Function(String) onArticlesRefresh;
  ErrorRequest({Key? key,required this.onArticlesRefresh}) : super(key: key);

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
            "回数制限の上限に達しました",
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
            "時間をおいてから再度お試しください",
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