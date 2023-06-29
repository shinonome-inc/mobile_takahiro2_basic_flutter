import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWebView extends StatefulWidget {
  final String initialUrl;
  final String redirectUrl;
  final Function(String) onTokenReceived;

  const LoginWebView({
    required this.initialUrl,
    required this.redirectUrl,
    required this.onTokenReceived,
    Key? key,
  }) : super(key: key);

  @override
  _LoginWebViewState createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  late WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: WebView(
        initialUrl: widget.initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith(widget.redirectUrl)) {
            // リダイレクトURLを検知したら、アクセストークン発行コードを抽出してコールバックする
            final Uri uri = Uri.parse(request.url);
            final String code = uri.queryParameters['code'] ?? '';
            widget.onTokenReceived(code);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
