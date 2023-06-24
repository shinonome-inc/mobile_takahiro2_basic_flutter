import 'package:flutter/material.dart';
import 'package:qiita_app/services/repository.dart';
import '../models/user_model.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late Future<List<User>> user = Future.value([]);

  @override
  void initState() {
    super.initState();
    initializeUser();
  }
  void initializeUser() async {
    user = (await QiitaClient.fetchAuthenticatedUser()) as Future<List<User>>;
    print(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<User>>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: Text("aa"),
            );
          }
        },
      ),
    );
  }
}
