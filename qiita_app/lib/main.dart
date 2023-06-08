<<<<<<< HEAD
=======
import 'package:flutter/material.dart';
import 'pages/top_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TopPage(),
    );
  }
}

>>>>>>> 08d3b8ec3cf0ac318561e41924a4b465007db815
