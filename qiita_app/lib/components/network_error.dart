import 'package:flutter/material.dart';
import 'package:qiita_app/components/elevated_button.dart';

class NetworkError extends StatelessWidget {
  const NetworkError({Key? key,required this.onTapReload}) : super(key: key);
  final Function() onTapReload;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 全体の背景色を白に設定
      body:
      Column(
        children: [
          Expanded(
            flex: 8,
            child: Container(),
          ),
          SizedBox(
            height: 66.67,
            width: 66.67,
            child: Image.asset(
              'images/no_internet.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            height: 17,
          ),
          const Text(
            "ネットワークエラー",
            style: TextStyle(
              fontSize: 14,
              fontFamily: "Noto Sans JP",
            ),
          ),
          const Text(
            "お手数ですが電波の良い場所で\n再度読み込みをお願いします",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(),
          ),
          GreenElevatedButton(onTap: onTapReload),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
