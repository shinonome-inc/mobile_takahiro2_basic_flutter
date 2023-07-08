// ignore_for_file: must_be_immutable
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qiita_app/components/green_elevated_button.dart';
import 'package:qiita_app/components/login_loading.dart';
import '../components/web_view.dart';
import '../services/repository.dart';
import 'package:qiita_app/pages/root_page.dart';
import '../models/url.model.dart';

class TopPage extends StatefulWidget {
  String redirecturl;

  TopPage({Key? key, required this.redirecturl}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  bool isLoading = false;
  Future<String>? accessToken;
  bool hasNetError = false;

  @override
  void initState() {
    super.initState();
    QiitaClient.getAccessToken().then((String? accessToken) {
      if (accessToken != null) {
        setLoading(true);
        _navigateToRootPage(context);
        setLoading(false);
      } else if (widget.redirecturl.contains(Url.require_redirect)) {
        setLoading(true);
        _loginToQiita();
        setLoading(false);
      }
    });
  }

  Future<void> checkConnectivityStatus() async {
    setState(() {});
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setNetError();
      setLoading(false);
    }
  }

  void setNetError() {
    setState(() {
      hasNetError = true;
    });
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
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
        _navigateToRootPage(context);
      }
      setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: isLoading
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
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.2), BlendMode.dstATop),
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
                            child: Container(),
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
                            child: Container(),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GreenElevatedButton(onTap: (){showModalBottomSheet<void>(
                                  context: context,
                                  useRootNavigator: true,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      height:
                                      MediaQuery.of(context).size.height *
                                          0.9,
                                      child: WebView(
                                        url: 'https://qiita.com/api/v2/oauth/authorize?client_id=${dotenv.env['clientId']}&scope=read_qiita',
                                      ),
                                    );
                                  },
                                );}, text: "ログイン"),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const RootPage()),
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
                            child: Container(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
