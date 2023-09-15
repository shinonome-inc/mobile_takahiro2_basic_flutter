import 'package:flutter/material.dart';
import 'package:qiita_app/components/web_view_screen.dart';

class ModalArticle extends StatelessWidget {
  final String url;
  const ModalArticle({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 11),
          alignment: Alignment.bottomCenter,
          height: 59,
          decoration: const BoxDecoration(
              color: Color.fromRGBO(249, 249, 249, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              )),
          child: const Text(
            'Article',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Pacifico-Regular', fontSize: 17),
          ),
        ),
        Expanded(child: WebViewScreen(url: url, title: 'Article',)),
      ],
    );
  }
}