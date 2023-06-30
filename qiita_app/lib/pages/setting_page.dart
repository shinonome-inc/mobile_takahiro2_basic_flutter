// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:qiita_app/components/default_app_bar.dart.dart';
import 'package:qiita_app/pages/top_page.dart';
import 'package:qiita_app/services/repository.dart';
import 'package:flutter/material.dart';

class MyListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My List'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListItem(
              title: 'プライバシーポリシー',
              onTap: () {
                // プライバシーポリシーがタップされたときの処理
                debugPrint('プライバシーポリシーがタップされました');
              },
            ),
            ListItem(
              title: '利用規約',
              onTap: () {
                // 利用規約がタップされたときの処理
                debugPrint('利用規約がタップされました');
              },
            ),
            ListItem(
              title: 'アプリケーションバージョン',
              onTap: () {
                // アプリケーションバージョンがタップされたときの処理
                debugPrint('アプリケーションバージョンがタップされました');
              },
            ),
            ListItem(
              title: 'ログアウト',
              onTap: () {
                // ログアウトがタップされたときの処理
                debugPrint('ログアウトがタップされました');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ListItem({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios_rounded),
      onTap: onTap,
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyListScreen(),
  ));
}




}



