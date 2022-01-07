import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_contron/screens/accout/accout.dart';
import 'package:flutter_contron/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_contron/screens/log/log_screen.dart';
import 'package:flutter_contron/screens/login/login_screen.dart';
import 'package:flutter_contron/screens/mode/mode_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    DashBoard(),
    ModeScreen(),
    LogScreen(),
    AccoutScreen(),
  ];

  void onTabTapped(int index) {
    print('index:' + index.toString());
    setState(() {
      _currentIndex = index;
      // เปลี่ยน title ไปตาม tab ที่เลือก
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          color: Colors.green,
          // backgroundColor: Colors.brown[900]!,
          backgroundColor: Color(0xFF0000),
          buttonBackgroundColor: Colors.green,
          height: 50,
          animationDuration: Duration(milliseconds: 300),
          index: _currentIndex,
          onTap: onTabTapped,
          items: [
            Icon(
              Icons.home,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.settings_applications_outlined,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.list_alt,
              size: 30,
              color: Colors.white,
            ), // บริการ
            Icon(Icons.account_circle, size: 30, color: Colors.white), //Ï
          ],
        ),
        body: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("assets/images/bg.jpeg"),
          //     fit: BoxFit.cover,
          //     colorFilter: ColorFilter.mode(
          //         Colors.black.withOpacity(0.7), BlendMode.dstATop),
          //   ),
          // ),
          child: Container(child: _children[_currentIndex]),
        ),
      ),
    );
  }
}
