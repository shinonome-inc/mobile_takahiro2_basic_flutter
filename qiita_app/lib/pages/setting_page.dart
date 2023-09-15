// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:qiita_app/components/default_app_bar.dart';
import 'package:qiita_app/components/text_sized_box.dart';
import 'package:qiita_app/pages/top_page.dart';
import 'package:qiita_app/models/texts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qiita_app/services/repository.dart';



class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  String? accessToken;
  bool isNoLogin = false;

  Future<void>checkAccessToken()async{
    accessToken = await QiitaClient.getAccessToken();
    if(accessToken==null){
      setState(() => isNoLogin = true);
    }
  }

  Future<void> deleteAccessToken() async {
    await QiitaClient.deleteAccessToken();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return TopPage(redirecturl: '',);
      }),
    );
  }




  @override
  void initState() {
    super.initState();
    checkAccessToken();
    getAppVersion();
  }
  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
  void deleteCurrentAccessToken() async {
    await QiitaClient.deleteAccessToken();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (_) => TopPage(redirecturl: 'https://',)),
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
              Container(
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
                  showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return const TextSizedBox(
                        privacyPolicyText: Texts.privacyPolicy,
                        appBarTitle: 'プライバシーポリシー',
                      );
                    },
                  );
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
                      const Expanded(
                        child: SizedBox(
                        ),
                      ),
                      const Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.grey
                      ),
                      Container(
                        width: 16,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return const TextSizedBox(
                        privacyPolicyText: Texts.termOfServiceText,
                        appBarTitle: '利用規約',
                      );
                    },
                  );
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
                      const Expanded(
                        child: SizedBox(
                        ),
                      ),
                      const Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.grey
                      ),
                      Container(
                        width: 16,
                      ),
                    ],
                  ),
                ),
              ),
            Container(
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
                    const Expanded(
                      child: SizedBox(
                      ),
                    ),
                    FutureBuilder<String>(
                      future: getAppVersion(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text('v ${snapshot.data}',style: const TextStyle(fontSize: 14));
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                    Container(
                      width: 16,
                    ),
                  ],
                ),
              ),
              Container(
                height: 20,
              ),
              Container(
                child: isNoLogin
                    ? Container()
                    : Column(
                  children: [
                    const ListTile(
                      title: Text(
                        'その他',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        deleteCurrentAccessToken();
                      },
                      child: Container(
                        color: Colors.white,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(16, 8.0, 8, 0),
                              height: 40,
                              child: const Text(
                                'ログアウトする',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: SizedBox(
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.grey,
                            ),
                            Container(
                              width: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}
