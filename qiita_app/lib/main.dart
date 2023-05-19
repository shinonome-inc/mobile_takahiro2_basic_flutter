import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body:Container(
        decoration: const BoxDecoration(
        image: DecorationImage(
        image: AssetImage('images/background.png'),
        fit: BoxFit.cover,
        ),),
            child:  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 250, 0, 0),
                    child: Text('Qiita Feed App',
                    style: TextStyle(
                      color: Colors.white, // テキストの色を白に設定
                      fontSize: 40, // テキストのフォントサイズを24に設定
                      fontFamily: 'Pacifico',
                    ),
                    ),
                  ),
                  const Text('-PlayGround-',
                    style: TextStyle(
                      color: Colors.white, // テキストの色を白に設定
                      fontSize: 13, // テキストのフォントサイズを24に設定
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 400, 0, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(70,131,1,1),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 130.0),
                        child: Text('ログイン',
                          style: TextStyle(
                            color: Colors.white, // テキストの色を白に設定
                            fontSize: 15, // テキストのフォントサイズを24に設定
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text('ログインせずに利用する',
                    style: TextStyle(
                      color: Colors.white, // テキストの色を白に設定
                      fontSize: 15, // テキストのフォントサイズを24に設定
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  ),
                ],
              )
            ),
        ),
      ),
    );
  }
}

