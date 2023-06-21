import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../pages/root_page.dart';
import 'default_app_bar.dart.dart';

class WebView extends StatefulWidget {
  final String url;
  const WebView({Key? key, required this.url}) : super(key: key);

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late WebViewController controller;
  double? pageHeight;
  bool isLoading = true;

  Future<void> calculateWebViewHeight(String url) async {
    const String javaScript = 'document.documentElement.scrollHeight;';
    final result = await controller.runJavaScriptReturningResult(javaScript);
    setState(() {
      debugPrint('UPDATE WebView contents height: $result');
      pageHeight = double.parse(result.toString());
    });
  }

  void onPageFinished(String url, {required WebViewController controller}) {
    final bool success =
    url.contains('https://qiita.com/settings/applications?code');
    if (success) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const RootPage(),
        ),
      );
    }
  }
  void _setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _setLoading(false);
            onPageFinished(url, controller: controller);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(20),
      ),
      child: Scaffold(
        appBar: const DefaultAppBar(text: 'Article'),
        body: SingleChildScrollView(
          child: SizedBox(
              height: pageHeight ?? MediaQuery.of(context).size.height * 0.9,
              child: !isLoading
                  ? WebViewWidget(
                controller: controller,
              )
                  : const Center(
                child: CircularProgressIndicator(),
              )
          ),
        ),
      ),
    );
  }
}