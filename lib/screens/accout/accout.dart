import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contron/models/datauserlogin.dart';

import 'package:flutter_contron/screens/accout/edit_password.dart';
import 'package:flutter_contron/screens/accout/editaccout.dart';
import 'package:flutter_contron/services/api.dart';
import 'package:flutter_contron/utilities/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AccoutScreen extends StatefulWidget {
  const AccoutScreen({Key? key}) : super(key: key);

  @override
  _AccoutScreenState createState() => _AccoutScreenState();
}

class _AccoutScreenState extends State<AccoutScreen> {
  DataUser? _dataUser;
  String? username;
  String? password;
  String? iduser;
  File? _image;
  String? name_flie;
  bool? aa = false;
  final picker = ImagePicker();
  final f = new DateFormat('yyyy-MM-dd');
  Future getImage(ImageSource imageSource) async {
    final pickedfile = await picker.getImage(source: imageSource);
    setState(() {
      if (pickedfile != null) {
        _image = File(pickedfile.path);
        print(_image);
        upload(_image!.path);
      } else {
        print('no image selected');
      }
    });
  }

  upload(filePath) async {
    try {
      final postUri =
          Uri.parse('https://sttslife-api.sttslife.co/upload-image/${iduser}');
      setState(() {
        name_flie = filePath.split('/').last;
      });
      print(name_flie);
      http.MultipartRequest request = http.MultipartRequest('POST', postUri);

      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'file',
        filePath,
        filename: name_flie,
        contentType: MediaType(
          'image',
          'png',
        ),
      ); //returns a Future<MultipartFile>
      request.files.add(multipartFile);
      http.StreamedResponse response = await request.send();
      //update_namefile();
      var responsed = await http.Response.fromStream(response);
      final responseData = json.decode(responsed.body);
      if (response.statusCode == 200) {
        print("SUCCESS");
        print(responseData);
      } else {
        print("ERROR");
      }
    } catch (err) {
      // tar_widget().showInSnackBar('กรุณาเชื่อมต่ออินเทอร์เน็ต', Colors.white,
      //     _scaffoldKey, Colors.red, 4);
    }
  }

  getUserprofile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    username = sharedPreferences.getString('user_username');
    password = sharedPreferences.getString('user_password');
    iduser = sharedPreferences.getString('userId');
    print('username : ${username}');
    print('password :${password}');
    print('iduser :${iduser}');
    var userData = {
      'user_username': username,
      'user_password': password,
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
    // getImage();
    getUserprofile();
  }

  getDataTime() {
    final dateNow = DateTime.now();
    final dateEnd = DateTime.parse('${_dataUser?.message?[0].userEndwaranty}');
    final differenceDay = dateEnd.difference(dateNow).inDays;
    return differenceDay;
  }

  @override
  Widget build(BuildContext context) {
    if (_dataUser != null) {
      getDataTime();

      return Container(
        child: Stack(
          children: [
            Container(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),

                      Text(
                        'ข้อมูลผู้ใช้',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[400]),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Center(
                        child: Stack(
                          children: [
                            // Container(
                            //   width: 130,
                            //   height: 130,
                            //   decoration: BoxDecoration(
                            //     border: Border.all(
                            //         width: 4,
                            //         color: Theme.of(context)
                            //             .scaffoldBackgroundColor),
                            //     boxShadow: [
                            //       BoxShadow(
                            //           spreadRadius: 2,
                            //           blurRadius: 10,
                            //           color: Colors.black.withOpacity(0.1),
                            //           offset: Offset(0, 10))
                            //     ],
                            //     shape: BoxShape.circle,
                            //     image: DecorationImage(
                            //       image: imgVariable,
                            //       fit: BoxFit.cover,
                            //     ),
                            //   ),
                            // ),
                            Container(
                              // decoration: BoxDecoration(
                              //   border: Border.all(
                              //       width: 4,
                              //       color: Theme.of(context)
                              //           .scaffoldBackgroundColor),
                              //   boxShadow: [
                              //     BoxShadow(
                              //         spreadRadius: 2,
                              //         blurRadius: 10,
                              //         color: Colors.black.withOpacity(0.1),
                              //         offset: Offset(0, 10))
                              //   ],
                              //   shape: BoxShape.circle,

                              // ),

                              child: Image.network(
                                'https://sttslife-api.sttslife.co/images/${iduser}.png',
                                height: 130,
                                width: 130,
                                fit: BoxFit.cover,
                                errorBuilder: (context, exception, stackTrace) {
                                  return Image.asset(
                                    'assets/images/logo.png',
                                    fit: BoxFit.cover,
                                    height: 130,
                                    width: 130,
                                  );
                                },
                              ),
                            ),

                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 4,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    color: Colors.green,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      print('editimageÏ');

                                      showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) =>
                                            CupertinoActionSheet(
                                          title: Text("เลือกรายการที่ต้องการ"),
                                          actions: [
                                            CupertinoActionSheetAction(
                                              onPressed: () {
                                                getImage(ImageSource.camera);
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Camera",
                                              ),
                                            ),
                                            CupertinoActionSheetAction(
                                              onPressed: () {
                                                getImage(ImageSource.gallery);
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Gallery",
                                              ),
                                            )
                                          ],
                                          cancelButton: CupertinoDialogAction(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'Cancel',
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                              onPressed: () {
                                print('เปลี่ยนรหัสผ่าน');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditPassword()));
                              },
                              child: Text(
                                'เปลี่ยนรหัสผ่าน',
                                style: TextStyle(color: Colors.green[400]),
                              )),
                        ],
                      ),
                      Divider(
                        thickness: 0.4,
                        color: Colors.green[400],
                      ),
                      ListTile(
                        title: Text(
                          'ข้อมูลส่วนตัว',
                          style: kProfileStyle,
                        ),
                      ),
                      ListTile(
                        title: Text('ชื่อผู้ใช้'),
                        subtitle: Text(
                          '${_dataUser?.message?[0].userUsername.toString()}',
                        ),
                      ),
                      ListTile(
                        title: Text('เบอร์โทรศัพท์'),
                        subtitle: Text(
                          '${_dataUser?.message?[0].userTel}',
                        ),
                      ),
                      ListTile(
                        title: Text('ข้อมูลผู้ใช้งาน'),
                        subtitle: Text(
                          '${_dataUser?.message?[0].userDetail}',
                        ),
                      ),
                      ListTile(
                        title: Text('สถานที่ติดตั้ง'),
                        subtitle: Text(
                          '${_dataUser?.message?[0].userLocaltion}',
                        ),
                      ),
                      // Divider(
                      //   thickness: 1,
                      //   color: Colors.green[400],
                      // ),

                      ListTile(
                        title: Text(
                          'รายการติดตั้ง',
                          style: kProfileStyle,
                        ),
                      ),
                      ListTile(
                        title: Text('หมายเลขคำสั่งซื้อ'),
                        subtitle: Text(
                          '${_dataUser?.message?[0].userPurchaseorder}',
                        ),
                      ),
                      ListTile(
                        title: Text('ยี่ห้อ'),
                        subtitle: Text(
                          '${_dataUser?.message?[0].airBrand}',
                        ),
                      ),
                      ListTile(
                        title: Text('ขนาด'),
                        subtitle: Text(
                          '${_dataUser?.message?[0].airBtu}',
                        ),
                      ),
                      ListTile(
                        title: Text('ประเภท'),
                        subtitle: Text(
                          '${_dataUser?.message?[0].airSpecies}',
                        ),
                      ),
                      ListTile(
                        title: Text('ชนิด'),
                        subtitle: Text(
                          '${_dataUser?.message?[0].airType}',
                        ),
                      ),
                      ListTile(
                        title: Text('อายุการใช้งาน'),
                        subtitle: Text(
                          '${_dataUser?.message?[0].airLifetime}',
                        ),
                      ),
                      ListTile(
                        title: Text('วันเริ่มประกัน'),
                        subtitle: Text(
                          f.format(
                            DateTime.parse(
                                '${_dataUser?.message?[0].userStartwaranty}'),
                          ),
                        ),
                      ),
                      // ListTile(
                      //   title: Text('วันหมดประกัน'),
                      //   subtitle: Text(
                      //     f.format(
                      //       DateTime.parse(
                      //           '${_dataUser?.message?[0].userEndwaranty}'),
                      //     ),
                      //   ),
                      //   trailing: Text(
                      //     'จะหมดอายุอีก : ${differenceDay} วัน',
                      //     style: TextStyle(color: Colors.black54),
                      //   ),
                      // ),
                      ListTile(
                        title: Text('วันหมดประกัน'),
                        subtitle: Text(
                          f.format(
                            DateTime.parse(
                                '${_dataUser?.message?[0].userEndwaranty}'),
                          ),
                        ),
                        trailing: Text(
                          'จะหมดอายุอีก : ${getDataTime()} วัน',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Divider(
                        thickness: 0.4,
                        color: Colors.green[400],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlineButton(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () async {
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              sharedPreferences.remove('test_image');
                              sharedPreferences.remove('userId');
                              sharedPreferences.remove('user_modes');
                              sharedPreferences.setInt('appStep', 2);
                              Navigator.pushReplacementNamed(context, '/login');
                              // loginUser(userData);
                              print('logout');
                            },
                            child: Text("Logout",
                                style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 2.2,
                                    color: Colors.black)),
                          ),
                          RaisedButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditAccoutScreen()));
                              // Navigator.pushNamed(
                              //     context, '/editaccout');
                              // // loginUser(userData);
                              print('editprofile');
                            },
                            color: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: SpinKitFadingCircle(
          duration: Duration(milliseconds: 2000),
          color: Colors.blue,
          size: 50.0,
        ),
      );
    }
  }
}
