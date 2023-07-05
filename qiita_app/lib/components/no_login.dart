import 'package:flutter/material.dart';
import 'package:qiita_app/components/green_elevated_button.dart';
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
            "マイページ機能を利用するには\nログインを行っていただく必要があります。",
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
          GreenElevatedButton(onTap:(){
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
          }, text: 'ログインする',),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
