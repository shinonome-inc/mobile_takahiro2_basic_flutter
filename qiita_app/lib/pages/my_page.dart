import 'package:flutter/material.dart';
import 'package:qiita_app/services/repository.dart';
import '../models/user_model.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late Future<User>? user;

  @override
  void initState() {
    super.initState();
    initializeUser();
  }

  Future<void> initializeUser() async {
    user = QiitaClient.fetchAuthenticatedUser();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return Center(child: Text(user.followeesCount.toString()));
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load user: ${snapshot.error}'));
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
