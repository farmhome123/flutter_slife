import 'package:flutter/material.dart';


import 'package:flutter_contron/screens/accout/accout.dart';
import 'package:flutter_contron/screens/accout/editaccout.dart';
import 'package:flutter_contron/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_contron/screens/home/home_screen.dart';
import 'package:flutter_contron/screens/log/log_screen.dart';
import 'package:flutter_contron/screens/login/login_screen.dart';
import 'package:flutter_contron/screens/mode/mode_screen.dart';
import 'package:flutter_contron/screens/notifications/notifications_screen.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/login": (BuildContext context) => LoginScreen(),
  "/home": (BuildContext context) => HomeScreen(),
  "/dashboard": (BuildContext context) => DashBoard(),
  "/accout": (BuildContext context) => AccoutScreen(),
  "/notification": (BuildContext context) => NotificationScreen(),
  "/log": (BuildContext context) => LogScreen(),
  "/editaccout": (BuildContext context) => EditAccoutScreen(),
  "/mode": (BuildContext context) => ModeScreen(),
};
