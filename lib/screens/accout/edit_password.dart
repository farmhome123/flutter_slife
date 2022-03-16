import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_contron/models/datauserlogin.dart';
import 'package:flutter_contron/services/api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({Key? key}) : super(key: key);

  @override
  _EditPasswordState createState() => _EditPasswordState();
}

DataUser? _dataUser;
TextEditingController? _passwordController;

class _EditPasswordState extends State<EditPassword> {
  bool showPassworddefault = true;
  bool showPasswordnew = true;
  bool showPasswordconfrim = true;
  bool _validate = true;

  final _passworddefalutController = TextEditingController();
  final _newpasswordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  String? username;
  String? password;
  DataUser? _dataUserres;

  String? get _errorTextdefalut {
    final text = _passworddefalutController.value.text;
    if (text.isEmpty) {
      setState(() {
        _validate = false;
      });
      return 'กรุณากรอกรหัสผ่านเก่า';
    }
    if (text.length < 6) {
      setState(() {
        _validate = false;
      });
      return 'รหัสผ่านต้องมากกว่า 6 ตัว';
    }
    if (text != _passwordController!.text) {
      setState(() {
        _validate = false;
      });
      return 'รหัสผ่านเก่าผิด';
    }
    return null;
  }

  String? get _errorTextnew {
    final text = _newpasswordController.value.text;

    if (text.isEmpty) {
      setState(() {
        _validate = false;
      });
      return 'กรุณากรอกรหัสผ่านใหม่';
    }
    if (text.length < 6) {
      setState(() {
        _validate = false;
      });
      return 'รหัสผ่านต้องมากกว่า 6 ตัว';
    }
    return null;
  }

  String? get _errorTextconfirm {
    final text = _confirmpasswordController.value.text;

    if (text.isEmpty) {
      setState(() {
        _validate = false;
      });
      return 'กรุณากรอกใหม่';
    }
    if (text.length < 6) {
      setState(() {
        _validate = false;
      });
      return 'รหัสผ่านต้องมากกว่า 6 ตัว';
    }
    if (text != _newpasswordController.text) {
      setState(() {
        _validate = false;
      });
      return 'รหัสผ่านใหม่ไม่ตรงกัน';
    }
    setState(() {
      _validate = true;
    });
    return null;
  }

  @override
  void dispose() {
    _passworddefalutController.dispose();
    _newpasswordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  Future<void> getUserprofile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    username = sharedPreferences.getString('user_username');
    password = sharedPreferences.getString('user_password');
    var userData = {
      'user_username': username,
      'user_password': password,
    };

    try {
      var res = await CallAPI().getProfile(userData);
      print(res);
      setState(() {
        _dataUser = res;
        _passwordController =
            TextEditingController(text: _dataUser?.message?[0].userPassword);
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> editUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userDataEdit = {
      "user_id": _dataUser?.message?[0].userId.toString(),
      "user_username": _dataUser!.message?[0].userUsername.toString(),
      "user_password": _newpasswordController.text,
      "user_detail": _dataUser!.message?[0].userDetail.toString(),
      "user_localtion": _dataUser!.message?[0].userLocaltion.toString(),
      "user_type": _dataUser?.message?[0].userType.toString(),
      "user_purchaseorder": _dataUser?.message?[0].userPurchaseorder.toString(),
      "user_tel": _dataUser?.message?[0].userTel.toString(),
      "air_brand": _dataUser?.message?[0].airBrand.toString(),
      "air_btu": _dataUser?.message?[0].airBtu.toString(),
      "air_type": _dataUser?.message?[0].airType.toString(),
      "air_lifetime": _dataUser?.message?[0].airLifetime.toString(),
    };
    var res = await http.put(
        Uri.parse('https://sttslife-api.sttslife.co/users/'),
        body: userDataEdit);
    print(json.decode(res.body));
    print(userDataEdit);
    var body = json.decode(res.body);
    print(body);
    // var body = json.decode(res.body);
    // _dataUserres = dataUserFromJson(res.body);
    sharedPreferences.setString('user_password', _newpasswordController.text);
    print(sharedPreferences.get('user_password'));
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserprofile();
    print('getUserprofile');
  }

  DateTime timeBackPressed = DateTime.now();
  @override
  Widget build(BuildContext context) {
    Future<bool?>? showWarning(context) async => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Are you sure ?'),
              content: Text('do you want to exit an App'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('No'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('Yes'),
                ),
              ],
            ));
    if (_dataUser != null) {
      return WillPopScope(
        onWillPop: () async {
          final shouldPop = await showWarning(context);
          return shouldPop ?? false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 1,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.green,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.only(left: 16, top: 25, right: 16),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        'เปลี่ยนรหัสผ่าน',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 35.0),
                      child: TextField(
                        autofocus: true,
                        controller: _passworddefalutController,
                        obscureText: showPassworddefault,
                        decoration: InputDecoration(
                            // errorText: _passwordController == _passwordController
                            //     ? 'รหัสเก่าผิด'
                            //     : null,
                            suffixIcon: showPassworddefault
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showPassworddefault =
                                            !showPassworddefault;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.grey,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showPassworddefault =
                                            !showPassworddefault;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                            contentPadding: EdgeInsets.only(bottom: 3),
                            labelText: 'รหัสผ่านเก่า',
                            errorText: _errorTextdefalut,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: '',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            )),
                      ),
                    ),
                    /////รหัสผ่านใหม่//////
                    Padding(
                      padding: const EdgeInsets.only(bottom: 35.0),
                      child: TextField(
                        controller: _newpasswordController,
                        obscureText: showPasswordnew,
                        decoration: InputDecoration(
                            suffixIcon: showPasswordnew
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showPasswordnew = !showPasswordnew;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.grey,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showPasswordnew = !showPasswordnew;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                            contentPadding: EdgeInsets.only(bottom: 3),
                            labelText: 'รหัสผ่านใหม่',
                            errorText: _errorTextnew,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: '',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            )),
                      ),
                    ),

                    ///////ยืนยืนรหัสผ่านใหม่/////////
                    Padding(
                      padding: const EdgeInsets.only(bottom: 35.0),
                      child: TextField(
                        controller: _confirmpasswordController,
                        obscureText: showPasswordconfrim,
                        decoration: InputDecoration(
                            suffixIcon: showPasswordconfrim
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showPasswordconfrim =
                                            !showPasswordconfrim;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.grey,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showPasswordconfrim =
                                            !showPasswordconfrim;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                            contentPadding: EdgeInsets.only(bottom: 3),
                            labelText: 'ยืนยันรหัสผ่านใหม่',
                            errorText: _errorTextconfirm,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: '',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlineButton(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("CANCEL",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.black)),
                        ),
                        RaisedButton(
                          onPressed: _validate
                              ? () {
                                  editUserData();
                                  print('edit');
                                }
                              : () {
                                  print('noedit');
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
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.blue[50],
        body: Center(
          child: SpinKitFadingCircle(
            duration: Duration(milliseconds: 2000),
            color: Colors.blue,
            size: 50.0,
          ),
        ),
      );
    }
  }

  // Widget buildTextField(
  //   String labelText,
  //   String placeholder,
  //   TextEditingController textcontroller,
  //   bool isPasswordTextField,
  // ) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 35.0),
  //     child: TextField(
  //       controller: textcontroller,
  //       obscureText: isPasswordTextField ? showPassword : false,
  //       decoration: InputDecoration(
  //           errorText: _validate ? 'รหัสผ่านผิด' : null,
  //           suffixIcon: isPasswordTextField
  //               ? IconButton(
  //                   onPressed: () {
  //                     setState(() {
  //                       showPassword = !showPassword;
  //                     });
  //                   },
  //                   icon: Icon(
  //                     Icons.remove_red_eye,
  //                     color: Colors.grey,
  //                   ),
  //                 )
  //               : null,
  //           contentPadding: EdgeInsets.only(bottom: 3),
  //           labelText: labelText,
  //           floatingLabelBehavior: FloatingLabelBehavior.always,
  //           hintText: placeholder,
  //           hintStyle: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.black,
  //           )),
  //     ),
  //   );
  // }
}
