// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qiita_app/components/default_app_bar.dart';
import 'package:qiita_app/components/text_sized_box.dart';
import 'package:qiita_app/models/texts.dart';
import 'package:qiita_app/pages/top_page.dart';
import 'package:qiita_app/services/repository.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String? accessToken;
  bool isNoLogin = true;

  Future<void> checkAccessToken() async {
    accessToken = await QiitaClient.getAccessToken();
    if (accessToken != null) {
      setState(() => isNoLogin = false);
    }
  }

  Future<void> deleteAccessToken() async {
    await QiitaClient.deleteAccessToken();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return TopPage(
          redirecturl: '',
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await checkAccessToken();
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
          builder: (_) => TopPage(
                redirecturl: 'https://',
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(text: 'Setting'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 32,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 0, 8),
            child: Text(
              "アプリ情報",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
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
                    padding: const EdgeInsets.fromLTRB(16, 8.0, 8.0, 0),
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
                    child: SizedBox(),
                  ),
                  const Icon(Icons.arrow_forward_ios_outlined,
                      color: Colors.grey),
                  Container(
                    width: 16,
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            color: Colors.grey, // 区切り線の色
            thickness: 0.3,
            height: 0.3, // 区切り線の太さ
            indent: 16,
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
                    padding: const EdgeInsets.fromLTRB(16, 8.0, 8.0, 0),
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
                    child: SizedBox(),
                  ),
                  const Icon(Icons.arrow_forward_ios_outlined,
                      color: Colors.grey),
                  Container(
                    width: 16,
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            color: Colors.grey, // 区切り線の色
            thickness: 0.3,
            height: 0.3, // 区切り線の太さ
            indent: 16,
          ),
          Container(
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 8.0, 8.0, 0),
                  height: 40,
                  child: const Text(
                    'アプリバージョン',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                FutureBuilder<String>(
                  future: getAppVersion(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text('v ${snapshot.data}',
                          style: const TextStyle(fontSize: 14));
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
          const Divider(
            color: Colors.grey, // 区切り線の色
            thickness: 0.3,
            height: 0.3, // 区切り線の太さ
            indent: 16,
          ),
          Container(
            height: 20,
          ),
          Container(
            child: isNoLogin
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 0, 8),
                        child: Text(
                          "その他",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
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
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8.0, 8, 0),
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
                                child: SizedBox(),
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
    );
  }
}
