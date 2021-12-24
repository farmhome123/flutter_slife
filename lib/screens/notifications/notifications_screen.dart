import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // decoration: BoxDecoration(
      //   color: Color(0xFc1d7b3),
      // ),
      child: Center(
        child: Text(
          'คุณยังไม่มีการแจ้งเตือนในขณะนี้',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
