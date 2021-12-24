import 'dart:convert';

import 'package:flutter_contron/models/datauserlogin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_contron/services/api.dart';
import 'package:flutter_contron/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _username, _password;
  DataUser? _dataUser;
  void _loginProcess(userData) async {
    var eiei = {
      'user_username': 'user11',
      'user_password': 12345678,
    };

    try {
      var bodyEncoded = json.encode(userData);
      var response = await CallAPI().loginAPI(bodyEncoded);
      var body = json.decode(response.body);
      _dataUser = dataUserFromJson(response.body);
      // print(response.body);
      print(_dataUser);
      print(_dataUser?.message[0].userId);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      sharedPreferences.setInt('appStep', 1);
      sharedPreferences.setString('userId', '${_dataUser?.message[0].userId}');
      SpinKitFadingCircle(
        duration: Duration(milliseconds: 2000),
        color: Colors.blue,
        size: 50.0,
      );
      // sharedPreferences.setInt('userId', value)
      Navigator.pushNamed(context, '/home');
    } catch (error) {
      print(error);
    }
  }

  Widget _buildUername() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Username',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              setState(() {
                _username = value;
              });
            },
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'กรุณากรอก username',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: true,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                this._password = value;
              });
            },
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'กรุณากรอก password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  // Future<void> loginUser(userData) async {
  //   var bodyEncoded = json.encode(userData);
  //   print(bodyEncoded);
  //   var response = await http.post(
  //     Uri.parse('https://sttslife-api.komkawila.com/login'),
  //     body: bodyEncoded,
  //     headers: {
  //       "Content-Type": "application/json",
  //       'Accept': 'application/json'
  //     },
  //   );
  //   print(response.body);
  // }

  // Future<void> getuser() async {
  //   var res =
  //       await http.get(Uri.parse('https://sttslife-api.komkawila.com/users/1'));
  //   print(jsonDecode(res.body));
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF73AEF5),
                  Color(0xFF61A4F1),
                  Color(0xFF568DE0),
                  Color(0xFF398AE5),
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              ),
            ),
          ),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 40.9, vertical: 100.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(80.0),
                    child: Image.asset('assets/images/logo.png',
                        height: 150, fit: BoxFit.cover),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _buildUername(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildPassword(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 25.0),
                    width: double.infinity,
                    child: RaisedButton(
                      elevation: 5.0,
                      onPressed: () {
                        var userData = {
                          'user_username': _username,
                          'user_password': _password,
                        };
                        _loginProcess(userData);
                        // loginUser(userData);
                        print(userData);
                      },
                      padding: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Colors.white,
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Color(0xFF527DAA),
                          letterSpacing: 1.5,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
