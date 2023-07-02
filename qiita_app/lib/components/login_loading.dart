import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginLoading extends StatelessWidget {
  const LoginLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromRGBO(70, 131, 1, 1),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 130.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text(
                          'Login',
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
                  onPressed: () {},
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
          ColorFiltered(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
            ),
          ),
          const Center(
              child: CupertinoActivityIndicator(
            radius: 20.0,
            color: Colors.white,
          )),
        ],
      ),
    );
  }
}
