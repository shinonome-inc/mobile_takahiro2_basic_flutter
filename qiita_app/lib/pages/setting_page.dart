// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:qiita_app/components/default_app_bar.dart.dart';
import 'package:qiita_app/models/privacy_policy.dart';
import 'package:qiita_app/pages/top_page.dart';
import 'package:qiita_app/services/repository.dart';
import 'package:package_info_plus/package_info_plus.dart';



class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Future<String>? accessToken;
  bool isNoLogin = false;

  Future<void>checkAccessToken()async{
    accessToken = await QiitaClient.getAccessToken() as Future<String>?;
    if(accessToken==null){
      setState(() {
        isNoLogin=true;
      });
    }
  }

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
                  showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return FractionallySizedBox(
                        heightFactor: 0.9, // 修正: 画面の高さの90%
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: Container(
                            color: Colors.white,
                            child: const Scaffold(
                              appBar: DefaultAppBar(text: 'プライバシーポリシー'),
                              body: SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    texts.privacyPolicy,
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
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
                  showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return FractionallySizedBox(
                        heightFactor: 0.9, // 修正: 画面の高さの90%
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: Container(
                            color: Colors.white,
                            child: const Scaffold(
                              appBar: DefaultAppBar(text: 'プライバシーポリシー'),
                              body: SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    texts.termOfServiceText,
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
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
                      Expanded(
                        child: Container(
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
                      const SizedBox(
                        width: 16,
                      ),
                    ],
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
                  deleteCurrentAccessToken();
                },
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 8.0,8, 0),
                        height: 40,
                        child: isNoLogin
                            ?const Text('そもそもログインしてません', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),)
                            :const Text('ログアウトする', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),),
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
