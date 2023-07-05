import 'package:flutter/material.dart';
import 'package:qiita_app/components/web_view.dart';
import 'package:qiita_app/qiita_auth_key.dart';

class NoLogin extends StatelessWidget {
  const NoLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 全体の背景色を白に設定
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: Container(),
          ),
          const Text(
            "ログインが必要です",
            style: TextStyle(
              fontSize: 14,
              fontFamily: "Noto Sans JP",
            ),
          ),
          const SizedBox(
            height: 17,
          ),
          const Text(
            "マイページ機能を利用するには",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          const Text(
            "ログインを行っていただく必要があります。",
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
      Container(
        height: 50,
        width: 327,
        padding: const EdgeInsets.all(0.0),
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    useRootNavigator: true,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: const WebView(
                          url:
                              'https://qiita.com/api/v2/oauth/authorize?client_id=${QiitaAuthKey.clientId}&scope=read_qiita',
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromRGBO(70, 131, 1, 1),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14.0, horizontal: 130.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text(
                  'ログイン',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
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
