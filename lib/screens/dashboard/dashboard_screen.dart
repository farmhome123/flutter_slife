import 'dart:async';
import 'dart:convert';

import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contron/models/dataMax.dart';
import 'package:flutter_contron/models/datasocketio.dart';
import 'package:flutter_contron/models/user/datastateuser.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:knob_widget/knob_widget.dart';
import 'package:outlined_text/outlined_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  bool status = false;
  bool statusMode = false;
  String? _homeIcon;
  Timer? _timer;
  var value = 0;
  String? _message;
  DataSocket? _datasocket;
  Socket? socket;
  String? iduser;
  DataStateUser? dataStateUser;
  DataMax? dataMax;

  KnobController? _controller;
  double? _knobValue;
  double? _valueSlide = 0;
  double? _maximum;

  bool sleepmode = false;
  bool nightmode = false;
  bool logomode = false;

//https://apisocketio.komkawila.com/
  String? _setImage() {
    if (value < 30) {
      setState(() {
        _homeIcon = "assets/images/iconhome1.png";
      });
    } else {
      setState(() {
        _homeIcon = "assets/images/iconhome2.png";
      });
    }
  }

  Color? _setledyellow() {
    if (_datasocket?.ledy == '1') {
      return Colors.yellow;
    } else if (_datasocket?.ledy == '0') {
      return Colors.grey;
    } else {
      return Colors.grey;
    }
  }

  Color? _setledgreen() {
    if (_datasocket?.ledg == '1') {
      return Colors.green;
    } else if (_datasocket?.ledg == '0') {
      return Colors.grey;
    } else {
      return Colors.grey;
    }
  }

  Color? _setledred() {
    if (_datasocket?.ledr == '1') {
      return Colors.red;
    } else if (_datasocket?.ledr == '0') {
      return Colors.grey;
    } else {
      return Colors.grey;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setImage();
    getUserId();

    // _timer = new Timer(const Duration(milliseconds: 400), () {
    //   initializeSocket();
    // });

    if (iduser != null) {
      initializeSocket();
      getUserStatus();
    } else {
      _timer = new Timer(const Duration(milliseconds: 400), () {
        initializeSocket();
        getUserStatus();
      });
    }
  }

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      iduser = prefs.getString('userId');
    });
    print('iduser = ${iduser}');
  }

  ///192.168.0.109
  ///203.159.93.64
//192.168.1.112
  @override
  void dispose() {
    socket!
        .disconnect(); // --> disconnects the Socket.IO client once the screen is disposed
    super.dispose();
    _timer?.cancel();
  }

  // sendMessage(String message) {
  //   socket!.emit(
  //     "message",
  //     {
  //       "id": socket!.id,
  //       "message": message, //--> message to be sent

  //       "sentAt": DateTime.now().toLocal().toString().substring(0, 16),
  //     },
  //   );
  // }???????????????
  sendMessage(String message) {
    socket!.emit("newChatMessage", {'body': '${message}'});
  }

//{"temperature": "22.28","ledyellow": "0","ledgreen": "1","ledred": "0","countred": "41","countyellow": "51"}
  Future sendStatus() async {
    var eiei = status ? 1 : 0;
    final body = {'user_enable': eiei.toString()};
    var res = await http.put(
        Uri.parse(
          'https://sttslife-api.sttslife.co/users/enable/${iduser}',
        ),
        body: body);
    if (res.statusCode == 200) {
      print('success ');
    } else {
      print('error');
    }
  }

  getUserStatus() async {
    var res = await http.get(Uri.parse(
      'https://sttslife-api.sttslife.co/users/${iduser}',
    ));
    if (res.statusCode == 200) {
      print('success getUserStatus ');
      setState(() {
        dataStateUser = dataStateUserFromJson(res.body);
        status = dataStateUser!.message[0].userEnable == 0 ? false : true;
        nightmode = dataStateUser!.message[0].nightmode == 0 ? false : true;
        sleepmode = dataStateUser!.message[0].sleepmode == 0 ? false : true;
        logomode = dataStateUser!.message[0].logo == 0 ? false : true;
        _valueSlide = double.parse('${dataStateUser!.message[0].userPulseset}');
      });
      print('status = ${dataStateUser!.message[0].userEnable}');
      getMaxMode();
    } else {
      print('error');
    }
  }

  getMaxMode() async {
    var res = await http.get(Uri.parse(
        'https://sttslife-api.sttslife.co/config/id/${dataStateUser!.message[0].userModes}'));
    var data = json.encode(res.body);

    if (res.statusCode == 200) {
      setState(() {
        dataMax = dataMaxFromJson(res.body);
      });
      setState(() {
        _maximum = double.parse('${dataMax!.message![0].configPulsecount}');
      });
    } else {
      print('error');
    }
  }

  void initializeSocket() {
    print('initializeSocket');
    socket = io(
        'http://dns.sttslife.co:4000/',
        OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setQuery({"roomId": iduser})
            .build());
    socket!.connect(); //connect the Socket.IO Client to the Server??
    //SOCKET EVENTS
    // --> listening for connection
    socket!.on('connect', (data) {
      print(socket!.connected);
    });
    //listen for incoming messages from the Server.
    socket!.on('newChatMessage', (data) {
      if ((data.toString()).indexOf('user_id') != -1) {
        setState(() {
          _message = data;
          _datasocket = DataSocket.fromJson(jsonDecode(data));
        });
      } else if ((data.toString()).indexOf('senderId') != -1) {
        final str = data.toString();
        final commands = str.substring(str.indexOf(':') + 2, str.indexOf(','));
        final atcommands = commands.substring(0, commands.indexOf('='));
        final values =
            commands.substring(commands.indexOf('=') + 1, commands.length);
        if (atcommands.indexOf('AT+TOGGLE') != -1) {
          print('############ AT+TOGGLE');
          setState(() {
            status = (int.parse(values) == 0 ? false : true);
          });
        } else if (atcommands.indexOf('AT+NIGHT') != -1) {
          print('############ AT+TOGGLE');
          setState(() {
            nightmode = (int.parse(values) == 0 ? false : true);
          });
        } else if (atcommands.indexOf('AT+SLEEP') != -1) {
          print('############ AT+SLEEP');
          setState(() {
            sleepmode = (int.parse(values) == 0 ? false : true);
          });
        } else if (atcommands.indexOf('AT+LOGO') != -1) {
          print('############ AT+LOGO');
          setState(() {
            logomode = (int.parse(values) == 0 ? false : true);
          });
        } else if (atcommands.indexOf('AT+PULSE') != -1) {
          print('atcommands = ${atcommands} & values = ${values}');
          setState(() {
            _valueSlide = double.parse('${values}');
          });
        } else if (atcommands.indexOf('AT+MODE') != -1) {
          print('AT+MODE');
          _timer = new Timer(const Duration(milliseconds: 400), () {
            /*  */
            getUserStatus();
          });
        }
      }

      // print(_datasocket);
      // print(_setledgreen);
    });

    // socket!.on('message', (data) {
    //   print(data); //
    // });

    //listens when the client is disconnected from the Server
    socket!.on('disconnect', (data) {
      print('disconnect');
    });
  }

  Future<void> sendSleepMode() async {
    try {
      var check = sleepmode ? 1 : 0;
      final body = {'sleepmode': check.toString()};
      var res = await http.put(
          Uri.parse(
            'https://sttslife-api.sttslife.co/users/sleepmode/${iduser}',
          ),
          body: body);
      if (res.statusCode == 200) {
        print('success sleepmode');
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendNightMode() async {
    try {
      var check = nightmode ? 1 : 0;
      final body = {'ninght': check.toString()};
      var res = await http.put(
          Uri.parse(
            'https://sttslife-api.sttslife.co/users/nightmode/${iduser}',
          ),
          body: body);
      if (res.statusCode == 200) {
        print('success nightmode');
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendLogomode() async {
    try {
      var check = logomode ? 1 : 0;
      final body = {'logo': check.toString()};
      var res = await http.put(
          Uri.parse(
            'https://sttslife-api.sttslife.co/users/logo/${iduser}',
          ),
          body: body);
      if (res.statusCode == 200) {
        print('success logomode');
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
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
    final Brightness _brightness = Theme.of(context).brightness;
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showWarning(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.green[300],
        //   centerTitle: true,
        //   title: Container(
        //     child: Image.asset(
        //       'assets/images/logomain1.png',
        //       height: 60,
        //     ),
        //   ),
        // ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              // Text(
              //   'App SLife',
              //   style: TextStyle(
              //       fontSize: 24,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.green[400]),
              // ),
              Container(
                child: Image.asset(
                  'assets/images/logomain1.png',
                  height: 70,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            _datasocket?.temp == null
                                ? SpinKitFadingCircle(
                                    duration: Duration(milliseconds: 2000),
                                    color: Colors.green[400],
                                    size: 40.0,
                                  )
                                : OutlinedText(
                                    strokes: [
                                      OutlinedTextStroke(
                                          width: 8,
                                          color: Color.fromARGB(
                                              255, 83, 136, 180)),
                                    ],
                                    text: Text(
                                      '${_datasocket?.temp}',

                                      // style: TextStyle(
                                      //   color: Colors.green,
                                      //   fontFamily: 'Facon',
                                      //   fontSize: 40.0,
                                      // ),
                                      style: GoogleFonts.kanit(
                                        color: Colors.white,
                                        letterSpacing: 3,
                                        fontSize: 40.0,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      // style: TextStyle(
                                      //   fontSize: 40.0,
                                      //   letterSpacing: -4,
                                      //   foreground: Paint()
                                      //     ..strokeWidth = 5
                                      //     ..color = Colors.green[400]!,
                                      // ),
                                    ),
                                  ),
                            SizedBox(
                              width: 14,
                            ),
                            SizedBox(
                              child: Image.asset(
                                'assets/images/iconhome1.png',
                                height: 50,
                              ),
                            ),
                            // Text(
                            //   ' ??C',
                            //   style: TextStyle(
                            //     fontSize: 40.0,
                            //     letterSpacing: -6,
                            //     foreground: Paint()
                            //       ..strokeWidth = 5
                            //       ..color = Colors.green[400]!,
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DecoratedIcon(
                    Icons.lightbulb,
                    color: _setledyellow(),
                    size: 40.0,
                    shadows: [
                      BoxShadow(
                        blurRadius: 42.0,
                        color: Colors.yellow,
                      ),
                      BoxShadow(
                        blurRadius: 12.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  DecoratedIcon(
                    Icons.lightbulb,
                    color: _setledgreen(),
                    size: 40.0,
                    shadows: [
                      BoxShadow(
                        blurRadius: 42.0,
                        color: Colors.green,
                      ),
                      BoxShadow(
                        blurRadius: 12.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  DecoratedIcon(
                    Icons.lightbulb,
                    color: _setledred(),
                    size: 40.0,
                    shadows: [
                      BoxShadow(
                        blurRadius: 42.0,
                        color: Colors.red,
                      ),
                      BoxShadow(
                        blurRadius: 12.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color.fromARGB(212, 28, 33, 37),
                      border: Border.all(
                        color: status ? Colors.green : Colors.red,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: status ? Colors.green[300]! : Colors.red[300]!,
                          blurRadius: 5,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          status = !status;
                          print(status);
                          // sendMessage(status.toString());
                          sendMessage('AT+TOGGLE=${status ? 1 : 0}');
                        });
                        sendStatus();
                      },
                      child: Icon(
                        Icons.power_settings_new,
                        color: status ? Colors.green : Colors.red,
                        size: 45,
                      ),
                    ), //,
                  ),
                  // Container(
                  //   margin: EdgeInsets.all(10),
                  //   height: 80.0,
                  //   child: SizedBox.fromSize(
                  //     size: Size(80, 80), // button width and height
                  //     child: ClipOval(
                  //       child: Material(
                  //         color: Color.fromARGB(255, 23, 46, 56), // button color
                  //         child: InkWell(
                  //           splashColor: Color.fromRGBO(248, 177, 1, 1),
                  //           // splash color
                  //           onTap: () {
                  //             statusMode = !statusMode;
                  //             print("statusMode ===> $statusMode");
                  //             setState(() {});
                  //           },
                  //           // button pressed
                  //           child: Icon(
                  //             Icons.power_settings_new,
                  //             color: statusMode ? Colors.green : Colors.red,
                  //             size: 45,
                  //           ), //,
                  //           // child: Column(
                  //           //   mainAxisAlignment: MainAxisAlignment.center,
                  //           //   children: <Widget>[
                  //           //     Icon(
                  //           //       Icons.power_settings_new,
                  //           //       color: Colors.white,
                  //           //     ), // icon
                  //           //     Text(
                  //           //       "ON",
                  //           //       style: TextStyle(
                  //           //         fontSize: 15,
                  //           //         color: Colors.white,
                  //           //       ),
                  //           //     ), // text
                  //           //   ],
                  //           // ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 2),
                            borderRadius: BorderRadius.circular(15)),
                        width: MediaQuery.of(context).size.width / 3.2,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text('NIGHT MODE'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FlutterSwitch(
                                activeColor: Colors.green,
                                toggleColor: Colors.white,
                                width: MediaQuery.of(context).size.width / 3.5,
                                height: 40.0,
                                valueFontSize: 18.0,
                                toggleSize: 45.0,
                                value: nightmode,
                                borderRadius: 30.0,
                                padding: 5.0,
                                showOnOff: true,
                                activeText: 'Night',
                                inactiveText: 'Ligth',
                                inactiveColor: Colors.grey,
                                activeIcon: Icon(
                                  Icons.nightlight_round,
                                  color: Colors.green,
                                ),
                                inactiveIcon: Icon(
                                  Icons.wb_sunny,
                                  color: Colors.grey,
                                ),
                                onToggle: (val) {
                                  setState(() {
                                    nightmode = val;
                                    print("nightmode ===> $nightmode");
                                    sendMessage(
                                        'AT+NIGHT=${nightmode ? 1 : 0}');
                                  });
                                  sendNightMode();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(15)),
                        width: MediaQuery.of(context).size.width / 3.2,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text('SLEEP MODE'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FlutterSwitch(
                                activeColor: Colors.green,
                                toggleColor: Colors.white,
                                width: MediaQuery.of(context).size.width / 3.5,
                                height: 40.0,
                                valueFontSize: 18.0,
                                toggleSize: 45.0,
                                value: sleepmode,
                                borderRadius: 30.0,
                                padding: 5.0,
                                showOnOff: true,
                                activeText: 'ON',
                                inactiveText: 'OFF',
                                inactiveColor: Colors.grey,
                                activeIcon: Icon(
                                  Icons.nightlight_round,
                                  color: Colors.green,
                                ),
                                // inactiveIcon: Icon(
                                //   Icons.wb_sunny,
                                //   color: Color(0xFFFFDF5D),
                                // ),
                                onToggle: (val) {
                                  setState(() {
                                    sleepmode = val;
                                    print("nightmode ===> $sleepmode");
                                    sendMessage(
                                        'AT+SLEEP=${sleepmode ? 1 : 0}');
                                  });
                                  sendSleepMode();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 2),
                            borderRadius: BorderRadius.circular(15)),
                        width: MediaQuery.of(context).size.width / 3.2,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text('LOGO'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FlutterSwitch(
                                activeColor: Colors.green,
                                toggleColor: Colors.white,
                                width: MediaQuery.of(context).size.width / 3.5,
                                height: 40.0,
                                valueFontSize: 18.0,
                                toggleSize: 45.0,
                                value: logomode,
                                borderRadius: 30.0,
                                padding: 5.0,
                                showOnOff: true,
                                activeText: 'ON',
                                inactiveText: 'OFF',
                                inactiveColor: Colors.grey,
                                // inactiveColor: Colors.yellow[300]!,
                                // activeIcon: Icon(
                                //   Icons.nightlight_round,
                                //   color: Color.fromARGB(255, 40, 55, 105),
                                // ),
                                // inactiveIcon: Icon(
                                //   Icons.wb_sunny,??
                                //   color: Color(0xFFFFDF5D),
                                // ),
                                onToggle: (val) {
                                  setState(() {
                                    logomode = val;
                                    print("nightmode ===> $logomode");
                                    sendMessage('AT+LOGO=${logomode ? 1 : 0}');
                                  });
                                  sendLogomode();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Container(
                  //   // padding: const EdgeInsets.all(15.0),
                  //   // decoration: BoxDecoration(
                  //   //   border: Border.all(
                  //   //     color: Colors.grey,
                  //   //     width: 2,
                  //   //   ),
                  //   // ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       FlutterSwitch(
                  //         activeColor: Colors.blue[200]!,
                  //         toggleColor: Colors.white,
                  //         width: 110.0,
                  //         height: 40.0,
                  //         valueFontSize: 20.0,
                  //         toggleSize: 45.0,
                  //         value: nightmode,
                  //         borderRadius: 30.0,
                  //         padding: 5.0,
                  //         showOnOff: true,
                  //         activeText: 'Night',
                  //         inactiveText: 'Ligth',
                  //         inactiveColor: Colors.grey,
                  //         activeIcon: Icon(
                  //           Icons.nightlight_round,
                  //           color: Color.fromARGB(255, 40, 55, 105),
                  //         ),
                  //         inactiveIcon: Icon(
                  //           Icons.wb_sunny,
                  //           color: Colors.grey,
                  //         ),
                  //         onToggle: (val) {
                  //           setState(() {
                  //             nightmode = val;
                  //             print("nightmode ===> $nightmode");
                  //             sendMessage('AT+NIGHT=${nightmode ? 1 : 0}');
                  //           });
                  //           sendNightMode();
                  //         },
                  //       ),
                  //       Expanded(
                  //         child: Container(
                  //           height: 90.0,
                  //           child: Card(
                  //             child: Stack(
                  //               children: [
                  //                 Positioned(
                  //                     top: 5, left: 5, child: Text('LOGOMODE')),
                  //                 Padding(
                  //                   padding: const EdgeInsets.all(8.0),
                  //                   child:
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // FlutterSwitch(
                  //   activeColor: Colors.green[400]!,
                  //   toggleColor: Colors.white,
                  //   width: 120.0,
                  //   height: 40.0,
                  //   valueFontSize: 25.0,
                  //   toggleSize: 45.0,
                  //   value: status,
                  //   borderRadius: 30.0,
                  //   padding: 5.0,
                  //   showOnOff: true,
                  //   onToggle: (val) {
                  //     setState(() {
                  //       status = val;
                  //       print(status);
                  //       // sendMessage(status.toString());
                  //       sendMessage('AT+TOGGLE=${status ? 1 : 0}');
                  //     });
                  //     sendStatus();
                  //   },
                  // ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          print('???????????????????????????');
                          // sendMessage('AT+TEST=1');
                          _showMaterialDialog();
                        },
                        icon: Icon(Icons.monitor),
                        tooltip: '???????????????????????????',
                        iconSize: 50,
                        color: Colors.green[400]!,
                      ),
                      Text(
                        '???????????????????????????',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(15)),
                  child: dataMax?.message?[0].configPulsecount == null
                      ? SpinKitFadingCircle(
                          duration: Duration(milliseconds: 2000),
                          color: Colors.blue,
                          size: 20.0,
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SfLinearGauge(
                            minimum: 0.0,
                            maximum: _maximum!,
                            interval: (_maximum! / 10.0),
                            animateAxis: true,
                            axisTrackStyle: const LinearAxisTrackStyle(
                                thickness: 24, color: Colors.green),
                            orientation: LinearGaugeOrientation.horizontal,
                            markerPointers: [
                              LinearWidgetPointer(
                                value: _valueSlide!,
                                onChanged: (value1) {
                                  setState(() {
                                    _valueSlide = value1;
                                  });
                                },
                                onChangeEnd: (valueslide) async {
                                  sendMessage(
                                      'AT+PULSE=${valueslide.toStringAsFixed(0)}');
                                  var res = await http.put(
                                      Uri.parse(
                                          'https://sttslife-api.sttslife.co/users/pulse/${iduser}'),
                                      body: {
                                        'user_pulseset':
                                            valueslide.toStringAsFixed(0)
                                      });
                                  if (res.statusCode == 200) {
                                    print('put valueSlide Success');
                                  } else {
                                    print('error');
                                  }
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.height * 0.05,
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        OutlinedText(
                                          strokes: [
                                            OutlinedTextStroke(
                                                color: Colors.green, width: 3),
                                          ],
                                          text: Text(
                                            _valueSlide!.toStringAsFixed(0),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Icon(
                                          Icons.circle,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 90,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.green, width: 2),
                            borderRadius: BorderRadius.circular(20.0)),
                        elevation: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Count Red',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            _datasocket?.countred == null
                                ? SpinKitFadingCircle(
                                    duration: Duration(milliseconds: 2000),
                                    color: Colors.blue,
                                    size: 20.0,
                                  )
                                : Text(
                                    '${_datasocket?.countred}',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[400]),
                                  )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 90,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.green, width: 2),
                            borderRadius: BorderRadius.circular(20.0)),
                        elevation: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Count Yellow',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            _datasocket?.countyellow == null
                                ? SpinKitFadingCircle(
                                    duration: Duration(milliseconds: 2000),
                                    color: Colors.blue,
                                    size: 20.0,
                                  )
                                : Text(
                                    '${_datasocket?.countyellow}',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[400]),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
    // }
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('??????????????????????????????????????????????????????????????????!'),
            content: Text(
              '??????????????????????????????',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Close',
                ),
              )
            ],
          );
        });
  }
}
