import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home:LeapYear(),
    );
  }
}

class LeapYear extends StatefulWidget {
  const LeapYear({Key? key}) : super(key: key);

  @override
  State<LeapYear> createState() => _LeapYearState();
}

class _LeapYearState extends State<LeapYear> {
  int year = 0;
  bool lepYear =false;
  String text = "";
  void main(){
    lepYear=isLeapYear(year);
    text = lepYear ? '$year年は閏年です' : '$year年は閏年ではありません';
  }
  bool isLeapYear(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) {
          return true; // 400で割り切れる年は閏年
        } else {
          return false; // 100で割り切れて、400で割り切れない年は平年
        }
      } else {
        return true; // 4で割り切れる年は閏年
      }
    } else {
      return false; // 4で割り切れない年は平年
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            Text(text,
              style: const TextStyle(
                fontSize: 20,),),
            TextField(
              onChanged: (text) {
                year = int.parse(text);
              },
            ),
            ElevatedButton(onPressed: (){
              setState(() {
                main();
              });
            }, child: const Text("RUN"),
            ),

          ],
        ),
      ),
    );
  }
}
