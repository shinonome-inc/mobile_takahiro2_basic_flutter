import 'package:flutter/material.dart';
import 'package:qiita_app/components/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:qiita_app/components/default_app_bar.dart';

class TextSizedBox extends StatelessWidget {
  final String privacyPolicyText;
  final String appBarTitle;

  const TextSizedBox({
    Key? key,
    required this.privacyPolicyText,
    required this.appBarTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        child: Container(
          color: Colors.white,
          child: Scaffold(
            appBar: DefaultAppBar(text: appBarTitle),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  privacyPolicyText,
                  style: const TextStyle(fontSize: 14.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
