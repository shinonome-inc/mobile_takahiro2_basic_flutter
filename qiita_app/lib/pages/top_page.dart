import 'package:flutter/material.dart';
import 'package:qiita_app/pages/root_page.dart';
import 'package:qiita_app/components/web_view.dart';
import 'package:qiita_app/pages/qiita_auth_key.dart';

import '../components/login_loading.dart';
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
  Future<String>? accessToken;



  @override
  void initState() {
    super.initState();
    QiitaClient.getAccessToken().then((String? accessToken) {
      if (accessToken != null) {
        setLoading(true);
        debugPrint('アクセストークンは$accessTokenです');
        _navigateToRootPage(context);
        setLoading(false);
      } else if (widget.redirecturl.contains(Url.require_redirect)) {
        setLoading(true);
        debugPrint('リダイレクトURLは${widget.redirecturl}です');
        _loginToQiita();
        setLoading(false);
      }
    });
  }


  void setLoading(bool value){
    setState(() {
      _isLoading = value;
    });
  }
  void _navigateToRootPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RootPage()),
    );
  }

  void _loginToQiita() {
    setLoading(true);
    QiitaClient.fetchAccessToken(widget.redirecturl).then((String? token) {
      if (token != null) {
        QiitaClient.saveAccessToken(token);
        debugPrint('アクセストークンを取得しました$token');
        _navigateToRootPage(context);
      }
      setLoading(false);
    });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _isLoading
        ? const LoginLoading() // ローディング画面を表示する
        : Stack(
          children: [
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