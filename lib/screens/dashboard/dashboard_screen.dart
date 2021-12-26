import 'dart:convert';
import 'dart:ffi';

import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contron/models/datasocketio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:socket_io_client/socket_io_client.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  bool status = false;
  String? _homeIcon;

  var value = 0;
  String? _message;
  DataSocket? _datasocket;
  Socket? socket;
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
    if (_datasocket?.ledyellow == '1') {
      return Colors.yellow;
    }
    if (_datasocket?.ledyellow == '0') {
      return Colors.grey;
    }
  }

  Color? _setledgreen() {
    if (_datasocket?.ledgreen == '1') {
      return Colors.green;
    }
    if (_datasocket?.ledgreen == '0') {
      return Colors.grey;
    }
  }

  Color? _setledred() {
    if (_datasocket?.ledred == '1') {
      return Colors.red;
    }
    if (_datasocket?.ledred == '0') {
      return Colors.grey;
    }
  }

  @override
  void initState() {
    _setImage();
    initializeSocket();
    // TODO: implement initState
    super.initState();
  }

  ///192.168.0.109
  ///203.159.93.64
//192.168.1.112
  @override
  void dispose() {
    socket!
        .disconnect(); // --> disconnects the Socket.IO client once the screen is disposed
    super.dispose();
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
    socket!
        .emit("newChatMessage", {'body': 'Testfarm', 'senderId': socket!.id});
  }
//{"temperature": "22.28","ledyellow": "0","ledgreen": "1","ledred": "0","countred": "41","countyellow": "51"}

  void initializeSocket() {
    socket = io(
        "http://dns.komkawila.com:4000/",
        OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setQuery({"roomId": '12'})
            .build());
    socket!.connect(); //connect the Socket.IO Client to the Serverƒ
    //SOCKET EVENTS
    // --> listening for connection
    socket!.on('connect', (data) {
      print(socket!.connected);
    });
    //listen for incoming messages from the Server.
    socket!.on('newChatMessage', (data) {
      // print(data); //
      setState(() {
        _message = data;
        _datasocket = DataSocket.fromJson(jsonDecode(data));
      });
      // print(_datasocket);
      // print(_setledgreen);
    });
    socket!.on('message', (data) {
      print(data); //
    });

    //listens when the client is disconnected from the Server
    socket!.on('disconnect', (data) {
      print('disconnect');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_datasocket == null) {
      return Center(
        child: SpinKitFadingCircle(
          duration: Duration(milliseconds: 2000),
          color: Colors.blue,
          size: 50.0,
        ),
      );
    }
    {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 6,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                color: Color(0xF6BC6D3),
                border: Border.all(color: Color(0xFF105BCF)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF105BCF).withOpacity(0.4),
                    spreadRadius: 4,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: new BorderRadius.only(
                  topRight: const Radius.circular(30),
                  topLeft: const Radius.circular(30),
                  bottomLeft: const Radius.circular(30),
                  bottomRight: const Radius.circular(30),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/iconhome1.png',
                      fit: BoxFit.fitHeight,
                      height: 100,
                    ),
                    Text(
                      '${_datasocket?.temperature}',
                      style: TextStyle(
                        fontSize: 50.0,
                        letterSpacing: -4,
                        foreground: Paint()
                          ..strokeWidth = 5
                          ..color = Colors.blue[400]!,
                      ),
                    ),
                    Text(
                      ' °C',
                      style: TextStyle(
                        fontSize: 50.0,
                        letterSpacing: -6,
                        foreground: Paint()
                          ..strokeWidth = 5
                          ..color = Colors.blue[400]!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
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
            height: 15,
          ),
          FlutterSwitch(
            activeColor: Color(0xFF105BCF),
            toggleColor: Colors.white,
            width: 125.0,
            height: 60.0,
            valueFontSize: 25.0,
            toggleSize: 45.0,
            value: status,
            borderRadius: 30.0,
            padding: 8.0,
            showOnOff: true,
            onToggle: (val) {
              setState(() {
                status = val;
                print(status);
                sendMessage(status.toString());
              });
            },
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 7,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                color: Color(0xF105BCF),
                border: Border.all(color: Color(0xFF105BCF)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF105BCF).withOpacity(0.4),
                    spreadRadius: 4,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: new BorderRadius.only(
                  topRight: const Radius.circular(30),
                  topLeft: const Radius.circular(30),
                  bottomLeft: const Radius.circular(30),
                  bottomRight: const Radius.circular(30),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Count Red: ${_datasocket?.countred}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 7,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                color: Color(0xF6BC6D3),
                border: Border.all(color: Color(0xFF105BCF)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF105BCF).withOpacity(0.4),
                    spreadRadius: 4,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: new BorderRadius.only(
                  topRight: const Radius.circular(30),
                  topLeft: const Radius.circular(30),
                  bottomLeft: const Radius.circular(30),
                  bottomRight: const Radius.circular(30),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Count Yellow: ${_datasocket?.countyellow}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
      );
    }
  }
}
