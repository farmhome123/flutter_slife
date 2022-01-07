import 'dart:convert';

import 'package:flutter_contron/models/datauserlogin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    var bodyEncoded = json.encode(userData);
    var response = await CallAPI().loginAPI(bodyEncoded);
    var body = json.decode(response.body);
    _dataUser = dataUserFromJson(response.body);
    print('${_dataUser}');
    if (_dataUser?.status == false) {
      _showDialog('มีข้อผิดพลาด', 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง');
    } else {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setInt('appStep', 1);
      sharedPreferences.setString('userId', '${_dataUser?.message?[0].userId}');
      sharedPreferences.setString(
          'user_username', '${_dataUser?.message?[0].userUsername}');
      sharedPreferences.setString(
          'user_password', '${_dataUser?.message?[0].userPassword}');
      sharedPreferences.setString(
          'user_modes', '${_dataUser?.message?[0].userModes}');
      SpinKitFadingCircle(
        duration: Duration(milliseconds: 2000),
        color: Colors.blue,
        size: 50.0,
      );
      // sharedPreferences.setInt('userId', value)
      Navigator.pushNamed(context, '/home');
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
            keyboardType: TextInputType.text,
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[300]!,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.9, vertical: 100.0),
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
                              color: Colors.green[400],
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

  void _showDialog(title, msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(msg),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'))
            ],
          );
        });
  }
}
