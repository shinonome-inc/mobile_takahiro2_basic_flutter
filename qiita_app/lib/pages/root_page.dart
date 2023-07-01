import 'package:flutter/material.dart';
import 'feed_page.dart';
import 'tag_page.dart';
import 'my_page.dart';
import 'setting_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  BottomNavigationPageState createState() => BottomNavigationPageState();
}

class BottomNavigationPageState extends State<RootPage> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    const FeedPage(),
    const TagPage(),
    const MyPage(),
    const SettingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: _widgetOptions[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted),
              label: 'フィード',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.label_outline),
              label: 'タグ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'マイページ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted),
              label: '設定',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
