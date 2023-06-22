import 'package:flutter/material.dart';
import 'package:qiita_app/pages/root_page.dart';
import 'package:qiita_app/components/web_view.dart';
import 'package:qiita_app/pages/qiita_auth_key.dart';

import '../models/url.model.dart';
import '../services/repository.dart';

// ignore: must_be_immutable
class TopPage extends StatefulWidget {
  String redirecturl;
  TopPage({Key? key, required this.redirecturl}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  bool _isLoading = false;
  Future<String?>? accesstoken =QiitaClient.getAccessToken();//Future<String>?nullable型

  @override
  void initState(){
    super.initState();
    //2回目以降のログイン
    if(accesstoken != null){
      // ignore: use_build_context_synchronously
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigateToRootPage(context);
      });
    }
    //初回ログイン
    else if(widget.redirecturl.contains(Url.require_redirect)){
      _loginToQiita();
    }
  }

  void setLoading(bool value){
    setState(() {
      _isLoading = value;
    });
  }
  void navigateToRootPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RootPage()),
    );
  }




  Future<void> _loginToQiita() async {
    setLoading (true);
    final token= await QiitaClient.fetchAccessToken(widget.redirecturl.toString());
    debugPrint('[accessToken]: $token');
    await QiitaClient.saveAccessToken(token!);
    debugPrint(await QiitaClient.getAccessToken());
    setLoading (false);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const RootPage(),//TODO LoginURLは存在するが、アクセストークンが存在しない条件分岐
      ),
          (_) => false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            if (_isLoading)//TODOローディング画面のデザインを綺麗にする。
              const Center(
                child: CircularProgressIndicator(),
              ),
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                    ),
                  ),
                  const Text(
                    'Qiita Feed App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                  const Text(
                    '-PlayGround-',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
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
                                    url: 'https://qiita.com/api/v2/oauth/authorize?client_id=${QiitaAuthKey.clientId}&scope=read_qiita',
                                  ),
                                );
                              },
                            );
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
                            'ログイン',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RootPage()),
                      );
                    },
                    child: const Text(
                      'ログインせずに利用する',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}