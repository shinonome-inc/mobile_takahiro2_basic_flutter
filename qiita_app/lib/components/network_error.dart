import 'package:flutter/material.dart';

class NetworkError extends StatelessWidget {
  const NetworkError({Key? key,required this.redirectWidget}) : super(key: key);
  final Widget redirectWidget;

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
            "お手数ですが電波の良い場所で",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          const Text(
            "再度読み込みをお願いします",
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
          ElevatedButton(
            onPressed: () {
              redirectWidget;
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromRGBO(70, 131, 1, 1),
              padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 130.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: const Text(
              '再度読み込みする',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
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
