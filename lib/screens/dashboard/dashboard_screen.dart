import 'dart:async';
import 'dart:convert';

import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contron/models/datasocketio.dart';
import 'package:flutter_contron/models/user/datastateuser.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:http/http.dart' as http;

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  bool status = false;
  String? _homeIcon;
  Timer? _timer;
  var value = 0;
  String? _message;
  DataSocket? _datasocket;
  Socket? socket;
  String? iduser;
  DataStateUser? dataStateUser;

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
  // }คำสั่
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
        status = dataStateUser!.message![0].userEnable == 0 ? false : true;
      });
      print('status = ${dataStateUser!.message![0].userEnable}');
    } else {
      print('error');
    }
  }

  void initializeSocket() {
    print('initializeSocket');
    socket = io(
        'http://dns.komkawila.com:4000/',
        OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setQuery({"roomId": iduser})
            .build());
    socket!.connect(); //connect the Socket.IO Client to the Serverƒ
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
            status = (int.parse(values) == 0 ? false : true) ; 
          });
        }
        //  else if (atcommands.indexOf('AT+MODE') != -1) {
        //   // เปลี่ยนโหมด
        // }
        print('atcommands = ${atcommands} & values = ${values}');
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            'App SLife',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[400]),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/iconhome1.png',
                  fit: BoxFit.fitHeight,
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        _datasocket?.temp == null
                            ? SpinKitFadingCircle(
                                duration: Duration(milliseconds: 2000),
                                color: Colors.green[400],
                                size: 50.0,
                              )
                            : Text(
                                '${_datasocket?.temp}',
                                style: TextStyle(
                                  fontSize: 50.0,
                                  letterSpacing: -4,
                                  foreground: Paint()
                                    ..strokeWidth = 5
                                    ..color = Colors.green[400]!,
                                ),
                              ),
                        Text(
                          ' °C',
                          style: TextStyle(
                            fontSize: 50.0,
                            letterSpacing: -6,
                            foreground: Paint()
                              ..strokeWidth = 5
                              ..color = Colors.green[400]!,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DecoratedIcon(
                Icons.lightbulb,
                color: _setledyellow(),
                size: 60.0,
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
                size: 60.0,
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
                size: 60.0,
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
          FlutterSwitch(
            activeColor: Colors.green[400]!,
            toggleColor: Colors.white,
            width: 120.0,
            height: 40.0,
            valueFontSize: 25.0,
            toggleSize: 45.0,
            value: status,
            borderRadius: 30.0,
            padding: 5.0,
            showOnOff: true,
            onToggle: (val) {
              setState(() {
                status = val;
                print(status);
                // sendMessage(status.toString());
                sendMessage('AT+TOGGLE=${status ? 1 : 0}');
              });
              sendStatus();
            },
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  print('ทดสอบระบบ');
                  sendMessage('AT+TEST=1');
                },
                icon: Icon(Icons.monitor),
                tooltip: 'ทดสอบระบบ',
                iconSize: 50,
                color: Colors.green[400]!,
              ),
              Text(
                'ทดสอบระบบ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 130,
                  width: MediaQuery.of(context).size.width / 2.5,
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
                  height: 130,
                  width: MediaQuery.of(context).size.width / 2.5,
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
    );
    // }
  }
}
