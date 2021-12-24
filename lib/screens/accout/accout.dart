import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_contron/models/datauserlogin.dart';
import 'package:flutter_contron/services/api.dart';
import 'package:flutter_contron/utilities/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccoutScreen extends StatefulWidget {
  const AccoutScreen({Key? key}) : super(key: key);

  @override
  _AccoutScreenState createState() => _AccoutScreenState();
}

class _AccoutScreenState extends State<AccoutScreen> {
  DataUser? _dataUser;
  getUserprofile() async {
    var userData = {
      'user_username': 'user11',
      'user_password': 12345678,
    };
    try {
      var res = await CallAPI().getProfile(userData);
      print(res);
      setState(() {
        _dataUser = res;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserprofile();
  }

  @override
  Widget build(BuildContext context) {
    if (_dataUser != null) {
      return Scaffold(
        body: Stack(
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
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Profile',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(80.0),
                        child: Image.network(
                            'https://image.freepik.com/free-vector/mysterious-mafia-man-smoking-cigarette_52683-34828.jpg',
                            height: 100,
                            fit: BoxFit.cover),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: kBoxDecorationStyle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          'ข้อมูลผู้ใช้: ',
                                          style: kProfileStyle,
                                        ),
                                        Text(
                                          '   ',
                                          style: kProfileStyle,
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${_dataUser?.message[0].userUsername}',
                                            style: kProfileStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Row(
                                //   children: [
                                //     Flexible(
                                //       child: Text(
                                //         'Add long text hereสก่หด้่าฟหสกาด้ฟ่หวกาด้ฟาสหก้ดา่ฟหส้ดา่สฟหก้ด้่กห้่าด่า้ฟหส้่ากด้ส่าฟห้ดกสาฟ่หสก้ดสา่ฟห้่กาดฟ้หกด้ฟาสห่กด้าส่ฟหก้fffffffasdasdasdasdadasdasdasdasdasdasdด่าสห',
                                //         maxLines: 3,
                                //         softWrap: true,
                                //         overflow: TextOverflow.clip,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                Divider(height: 10, thickness: 1.5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'เบอร์โทรศัพท์: ',
                                        style: kProfileStyle,
                                      ),
                                      Text(
                                        '   ',
                                        style: kProfileStyle,
                                      ),
                                      Text(
                                        '${_dataUser?.message[0].userTel}',
                                        style: kProfileStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(height: 10, thickness: 1.5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ข้อมูลผู้ใช้งาน: ',
                                        style: kProfileStyle,
                                      ),
                                      Text(
                                        '   ',
                                        style: kProfileStyle,
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${_dataUser?.message[0].userDetail}',
                                          style: kProfileStyle,
                                          maxLines: 3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(height: 10, thickness: 1.5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'สถานที่ติดตั้ง: ',
                                        style: kProfileStyle,
                                      ),
                                      Text(
                                        '   ',
                                        style: kProfileStyle,
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${_dataUser?.message[0].userLocaltion}',
                                          style: kProfileStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(height: 10, thickness: 1.5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'เข้าสู่ระบบล่าสุด: ',
                                        style: kProfileStyle,
                                      ),
                                      Text(
                                        DateFormat('วันที่ ' +
                                                'dd-MM-yyyy' +
                                                ' น.')
                                            .format(
                                          DateTime.now(),
                                        ),
                                        style: kProfileStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(height: 10, thickness: 1.5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'หมายเลขคำสั่งซื้อ: ',
                                        style: kProfileStyle,
                                      ),
                                      Text(
                                        '   ',
                                        style: kProfileStyle,
                                      ),
                                      Text(
                                        '${_dataUser?.message[0].userPurchaseorder}',
                                        style: kProfileStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(height: 10, thickness: 1.5),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'ยี่ห้อ: ',
                                        style: kProfileStyle,
                                      ),
                                      Text(
                                        '   ',
                                        style: kProfileStyle,
                                      ),
                                      Text(
                                        '${_dataUser?.message[0].airBrand}',
                                        style: kProfileStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(height: 10, thickness: 1.5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'ขนาด: ',
                                        style: kProfileStyle,
                                      ),
                                      Text(
                                        '   ',
                                        style: kProfileStyle,
                                      ),
                                      Text(
                                        '${_dataUser?.message[0].airBtu}',
                                        style: kProfileStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(height: 10, thickness: 1.5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'ขนิด: ',
                                        style: kProfileStyle,
                                      ),
                                      Text(
                                        '   ',
                                        style: kProfileStyle,
                                      ),
                                      Text(
                                        '${_dataUser?.message[0].airType}',
                                        style: kProfileStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(height: 10, thickness: 1.5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'อายุการใช้งาน: ',
                                        style: kProfileStyle,
                                      ),
                                      Text(
                                        '   ',
                                        style: kProfileStyle,
                                      ),
                                      Text(
                                        '${_dataUser?.message[0].airLifetime}',
                                        style: kProfileStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(height: 10, thickness: 1.5),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  width: double.infinity,
                                  child: RaisedButton(
                                    elevation: 5.0,
                                    onPressed: () async {
                                      Navigator.pushNamed(
                                          context, '/editaccout');
                                      // loginUser(userData);
                                      print('logout');
                                    },
                                    padding: EdgeInsets.all(15.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    color: Colors.grey,
                                    child: Text(
                                      'Edit Profile',
                                      style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 1.5,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'OpenSans',
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  width: double.infinity,
                                  child: RaisedButton(
                                    elevation: 5.0,
                                    onPressed: () async {
                                      SharedPreferences sharedPreferences =
                                          await SharedPreferences.getInstance();

                                      sharedPreferences.setInt('appStep', 2);
                                      Navigator.pushReplacementNamed(
                                          context, '/login');
                                      // loginUser(userData);
                                      print('logout');
                                    },
                                    padding: EdgeInsets.all(15.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    color: Colors.white,
                                    child: Text(
                                      'LOGOUT',
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
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.blue[50],
        body: Center(
          child: SpinKitFadingCube(
            duration: Duration(milliseconds: 2000),
            color: Colors.blue,
            size: 50.0,
          ),
        ),
      );
    }
  }

  Widget _buildUername() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 80.0,
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                hintText: 'ข้อมูลผู้ใช้ คุณ .....',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 80.0,
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.card_giftcard,
                  color: Colors.white,
                ),
                hintText: 'เบอร์โทรศัทพ์ .....',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildlocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 80.0,
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                hintText: 'สถานที่ติดตั้ง.....',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
