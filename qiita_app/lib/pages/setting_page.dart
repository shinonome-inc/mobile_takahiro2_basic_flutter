// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:qiita_app/components/default_app_bar.dart.dart';
import 'package:qiita_app/pages/top_page.dart';
import 'package:qiita_app/services/repository.dart';
class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  void deleteAccessToken() async {
    await QiitaClient.deleteAccessToken();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return TopPage(redirecturl: '',);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(text: 'Setting'),
      body: Container(
        color: const Color(0xFFF2F2F2),
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 32,
            ),
            const ListTile(
              title: Text('アプリ情報',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              )
              ),
            ),
            GestureDetector(
              onTap: () {
                debugPrint("タップされました");
              },
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 8.0,8.0, 0),
                        height: 40,
                        child: const Text(
                              'プライバシーポリシー',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                        ),

                      ),
                      const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.grey
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                ),
            ),
            GestureDetector(
              onTap: () {
                debugPrint("タップされました");
              },
              child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 8.0,8.0, 0),
                      height: 40,
                      child: const Text(
                        '利用規約',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                      ),

                    ),
                    const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.grey
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                debugPrint("タップされました");
              },
              child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 8.0,8.0, 0),
                      height: 40,
                      child: const Text(
                        'アプリケーションバージョン',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                      ),

                    ),
                    const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.grey
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const ListTile(
              title: Text('その他',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  )
              ),
            ),
            GestureDetector(
              onTap: () {
                QiitaClient.deleteAccessToken();
              },
              child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 8.0,8.0, 0),
                      height: 40,
                      child: const Text(
                        'ログアウトする',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                      ),

                    ),
                    const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.grey
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: Container(),),
            // 他のリストアイテムを追加できます
          ],
        ),
      )
    );
  }
}



