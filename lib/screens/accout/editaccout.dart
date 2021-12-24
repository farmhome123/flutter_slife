import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_contron/models/datauserlogin.dart';
import 'package:flutter_contron/services/api.dart';
import 'package:flutter_contron/utilities/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:http/http.dart' as http;

class EditAccoutScreen extends StatefulWidget {
  const EditAccoutScreen({Key? key}) : super(key: key);

  @override
  _EditAccoutScreenState createState() => _EditAccoutScreenState();
}

DataUser? _dataUser;
TextEditingController? _usernameController;

TextEditingController? _telController;

TextEditingController? _detailController;

TextEditingController? _locationController;

TextEditingController? _btuController;

TextEditingController? _lifetimeController;

class _EditAccoutScreenState extends State<EditAccoutScreen> {
  bool showPassword = false;

  List? _dataBrand;
  String? _myStateBrand = _dataUser?.message[0].airBrand;
  List? _dataType;
  String? _myStateType = _dataUser?.message[0].airType;

  Future<void> getUserprofile() async {
    var userData = {
      'user_username': 'user11',
      'user_password': 12345678,
    };
    try {
      var res = await CallAPI().getProfile(userData);
      print(res);
      setState(() {
        _dataUser = res;
        _usernameController =
            TextEditingController(text: _dataUser?.message[0].userUsername);

        _telController =
            TextEditingController(text: _dataUser?.message[0].userTel);

        _detailController =
            TextEditingController(text: _dataUser?.message[0].userDetail);

        _locationController =
            TextEditingController(text: _dataUser?.message[0].userLocaltion);

        _btuController =
            TextEditingController(text: _dataUser?.message[0].airBtu);

        _lifetimeController =
            TextEditingController(text: _dataUser?.message[0].airLifetime);
        _myStateBrand = _dataUser?.message[0].airBrand;
        _myStateType = _dataUser?.message[0].airType;
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> editUserData() async {
    var userDataEdit = {
      "user_id": _dataUser?.message[0].userId.toString(),
      "user_username": _usernameController!.text,
      "user_password": _dataUser?.message[0].userPassword.toString(),
      "user_detail": _detailController!.text,
      "user_localtion": _locationController!.text,
      "user_type": _dataUser?.message[0].userType.toString(),
      "user_purchaseorder": _dataUser?.message[0].userPurchaseorder.toString(),
      "user_tel": _telController!.text,
      "air_brand": _myStateBrand.toString(),
      "air_btu": _btuController!.text,
      "air_type": _myStateType.toString(),
      "air_lifetime": _lifetimeController!.text,
    };
    var res = await http.put(
        Uri.parse('https://sttslife-api.sttslife.co/users/'),
        body: userDataEdit);
    print(json.decode(res.body));
    print(userDataEdit);
    Navigator.pushNamed(context, '/home');
  }

  Future<void> getBrands() async {
    var res = await http
        .get(Uri.parse('https://sttslife-api.sttslife.co/air/brands'));
    var data = json.decode(res.body);
    setState(() {
      _dataBrand = data['message'];
    });
  }

  Future<void> getType() async {
    var res =
        await http.get(Uri.parse('https://sttslife-api.sttslife.co/air/types'));
    var data = json.decode(res.body);
    setState(() {
      _dataType = data['message'];
    });
  }

//https://sttslife-api.sttslife.co/air/types
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserprofile();
    getBrands();
    getType();
  }

  @override
  Widget build(BuildContext context) {
    if (_dataUser != null) {
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Edit Profile',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
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
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            buildTextField(
                                'ชื่อผู้ใช้งาน',
                                "${_dataUser?.message[0].userUsername}",
                                _usernameController!,
                                false),
                            buildTextField(
                                'เบอร์โทรศัทพ์ติดต่อ',
                                "${_dataUser?.message[0].userTel}",
                                _telController!,
                                false),
                            buildTextField(
                                'รายละเอียดข้อมูลผู้ใช้',
                                "${_dataUser?.message[0].userDetail}",
                                _detailController!,
                                false),
                            buildTextField(
                                'สถานที่ติดตั้ง',
                                "${_dataUser?.message[0].userLocaltion}",
                                _locationController!,
                                false),
                            buildTextField(
                                'ขนาดBTU',
                                "${_dataUser?.message[0].airBtu}",
                                _btuController!,
                                false),
                            buildTextField(
                                'อายุการใช้งาน',
                                "${_dataUser?.message[0].airLifetime}",
                                _lifetimeController!,
                                false),

                            Container(
                              padding:
                                  EdgeInsets.only(left: 15, right: 15, top: 5),
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          value: _myStateBrand,
                                          iconSize: 30,
                                          icon: (null),
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16,
                                          ),
                                          hint: Text('Select State'),
                                          onChanged: (newValue) {
                                            setState(() {
                                              _myStateBrand = newValue;

                                              print(_myStateBrand);
                                            });
                                          },
                                          items: _dataBrand?.map((item) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                      item['brand_name']),
                                                  value: item['brand_name']
                                                      .toString(),
                                                );
                                              })?.toList() ??
                                              [],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //////////////////////////////drop Type //////////////////////////

                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              padding:
                                  EdgeInsets.only(left: 15, right: 15, top: 5),
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          value: _myStateType,
                                          iconSize: 30,
                                          icon: (null),
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16,
                                          ),
                                          hint: Text('Select State'),
                                          onChanged: (newValue) {
                                            setState(() {
                                              _myStateType = newValue;

                                              print(_myStateType);
                                            });
                                          },
                                          items: _dataType?.map((item) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                      item['airtype_name']),
                                                  value: item['airtype_name']
                                                      .toString(),
                                                );
                                              })?.toList() ??
                                              [],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                OutlineButton(
                                  padding: EdgeInsets.symmetric(horizontal: 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/home');
                                  },
                                  child: Text("CANCEL",
                                      style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 2.2,
                                          color: Colors.black)),
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    editUserData();
                                  },
                                  color: Colors.green,
                                  padding: EdgeInsets.symmetric(horizontal: 50),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    "SAVE",
                                    style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 2.2,
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

  Widget buildTextField(
    String labelText,
    String placeholder,
    TextEditingController textcontroller,
    bool isPasswordTextField,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: textcontroller,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            labelStyle: kEditLabelStyle,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
      ),
    );
  }
}
