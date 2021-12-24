import 'package:flutter/material.dart';
import 'package:flutter_contron/routers.dart';
import 'package:flutter_contron/screens/home/home_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

var appStep;
var initURL;

Future<void> main() async {
  Intl.defaultLocale ='th';
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  appStep = prefs.getInt('appStep');
  print(appStep);
  if (appStep == 1) {
    initURL = '/home';
  } else if (appStep == 2) {
    initURL = '/login';
  } else {
    initURL = '/login';
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initURL,
      routes: routes,
    );
  }
}
