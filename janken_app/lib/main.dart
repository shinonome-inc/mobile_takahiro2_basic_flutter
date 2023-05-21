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
  String selectedHand = '✊';
  String computerHand = '✊';
  String result = '引き分け';

  void selectHand(String selectedHand)async {
    await Future.delayed(const Duration(seconds: 3));
    selectedHand = selectedHand;
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
    if (selectedHand == computerHand) {
      result = '引き分け';
    } else if (selectedHand == '✊' && computerHand == '✌️' ||
        selectedHand == '✌️' && computerHand == '🖐' ||
        selectedHand == '🖐' && computerHand == '✊') {
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
              style: const TextStyle(
                fontSize: 60,
              ),
            ),
            const SizedBox(height: 48),

            Text(
              computerHand,
              style: const TextStyle(
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 48),
            Text(
              selectedHand,
              style: const TextStyle(
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    selectHand('✊');
                  },
                  child: const Text('✊'),
                ),
                ElevatedButton(
                  onPressed: () {
                    selectHand('✌️');
                  },
                  child: const Text('✌️'),
                ),
                ElevatedButton(
                  onPressed: () {
                    selectHand('🖐');
                  },
                  child: const Text('🖐'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

