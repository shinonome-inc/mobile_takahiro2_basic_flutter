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
      body: Center(
        child: Column(
          children: [
            Column(
              children: [
                Container()
              ],
            ),
          ],
        )
      )
    );
  }




}



