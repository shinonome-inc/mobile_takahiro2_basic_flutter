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
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                image: const DecorationImage(
                  image: AssetImage('images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                  child: Column(
                children: [
                  const SizedBox(
                    height: 250,
                  ),
                  const Text(
                    'Qiita Feed App',
                    style: TextStyle(
                      color: Colors.white, // テキストの色を白に設定
                      fontSize: 40, // テキストのフォントサイズを40に設定
                      fontFamily: 'Pacifico',
                    ),
                  ),
                  const Text(
                    '-PlayGround-',
                    style: TextStyle(
                      color: Colors.white, // テキストの色を白に設定
                      fontSize: 13, // テキストのフォントサイズを13に設定
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // ボタンが押されたときの処理
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: const Color.fromRGBO(70, 131, 1, 1),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14.0, horizontal: 130.0),
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
                      onPressed: (){
                        //クリックされた時の処理
                  },
                      child: const Text('ログインせずに利用する',
                        style: TextStyle(
                          color: Colors.white, // テキストの色を白に設定
                          fontSize: 15, // テキストのフォントサイズを15に設定
                          fontWeight: FontWeight.bold,
                        ),
                      ),),
                  const SizedBox(
                    height: 70,
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
