import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const JankenPage(),
    );
  }
}

class JankenPage extends StatefulWidget {
  const JankenPage({super.key});

  @override
  State<JankenPage> createState() => _JankenPageState();
}

class _JankenPageState extends State<JankenPage> {
  String SelectedHand = '✊';
  String computerHand = '✊';
  String result = '引き分け';

  void selectHand(String selectedHand)async {
    await Future.delayed(Duration(seconds: 3));
    SelectedHand = selectedHand;
    generateComputerHand();
    judge();
    setState(() {});
  }

  void generateComputerHand() {
    final randomNumber = Random().nextInt(3);
    computerHand = randomNumberToHand(randomNumber);
  }

  String randomNumberToHand(int randomNumber) {
    switch (randomNumber) {
      case 0:
        return '✊';
      case 1:
        return '✌️';
      case 2:
        return '🖐';
      default:
        return '✊';
    }
  }

  void judge() {
    if (SelectedHand == computerHand) {
      result = '引き分け';
    } else if (SelectedHand == '✊' && computerHand == '✌️' ||
        SelectedHand == '✌️' && computerHand == '🖐' ||
        SelectedHand == '🖐' && computerHand == '✊') {
      result = '勝ち';
    } else {
      result = '負け';
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('じゃんけん'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              result,
              style: TextStyle(
                fontSize: 60,
              ),
            ),
            SizedBox(height: 48),

            Text(
              computerHand,
              style: TextStyle(
                fontSize: 32,
              ),
            ),
            SizedBox(height: 48),
            Text(
              SelectedHand,
              style: TextStyle(
                fontSize: 32,
              ),
            ),
            SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    selectHand('✊');
                  },
                  child: Text('✊'),
                ),
                ElevatedButton(
                  onPressed: () {
                    selectHand('✌️');
                  },
                  child: Text('✌️'),
                ),
                ElevatedButton(
                  onPressed: () {
                    selectHand('🖐');
                  },
                  child: Text('🖐'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

