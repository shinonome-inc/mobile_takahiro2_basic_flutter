import 'package:flutter/material.dart';

class NetworkError extends StatelessWidget {
  const NetworkError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:Center(
        child: Text("ネットワークエラー(レイアウト未完成)"),
      )
    );
  }
}
