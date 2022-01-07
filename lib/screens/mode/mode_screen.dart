import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_contron/models/datamode.dart';
import 'package:flutter_contron/models/datasocketio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ModeScreen extends StatefulWidget {
  const ModeScreen({Key? key}) : super(key: key);

  @override
  _ModeScreenState createState() => _ModeScreenState();
}

class _ModeScreenState extends State<ModeScreen> {
  DataModes? _dataModes;
  List<Message> _dataModesList = [];
  Socket? socket;
  String? iduser;
  Timer? _timer;
  String? _Textmode = 'default';
  int checkedIndex = 0;
  String? user_modes;
  DataSocket? _datasocket;
  String? _message;
  bool status = false;
// /#RT=user_id,modes_id$
  getMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    iduser = prefs.getString('userId');
    // user_modes = prefs.getString('user_modes');
    print('iduser = ${iduser}');
    var res = await http.get(Uri.parse(
        'https://sttslife-api.sttslife.co/config/' + iduser.toString()));

    try {
      if (res.statusCode == 200)
        setState(() {
          _dataModes = dataModesFromJson(res.body);
          // checkedIndex = int.parse(user_modes.toString());
        });
      _dataModesList = _dataModes?.message as List<Message>;
      // print(json.encode(_dataModes));
      print(_dataModesList);
      getUser(iduser);
    } catch (e) {
      print(e);
    }
  }

  getUser(id) async {
    var res = await http.get(
        Uri.parse('https://sttslife-api.sttslife.co/users/' + id.toString()));
    final indexuser_modes = res.body.indexOf('user_modes');
    final indexEnduser_modes = res.body.indexOf('}', indexuser_modes);
    final index_user_modes = res.body.indexOf(':', indexuser_modes + 5) + 1;
    final user_modes = res.body.substring(index_user_modes, indexEnduser_modes);

    print(user_modes);
    // _dataModesList.map((data)=>{
    //   print(data)
    // });
    for (var i = 0; i < _dataModesList.length; i++) {
      print(_dataModesList[i].configId);
      if (int.parse(user_modes) == _dataModesList[i].configId) {
        setState(() {
          checkedIndex = i;
        });
        break;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMode();
    // _timer = new Timer(const Duration(milliseconds: 400), () {
    //   initializeSocket();
    // });
    if (iduser != null) {
      initializeSocket();
    } else {
      _timer = new Timer(const Duration(milliseconds: 400), () {
        initializeSocket();
      });
    }
  }

  @override
  void dispose() {
    socket!
        .disconnect(); // --> disconnects the Socket.IO client once the screen is disposed
    super.dispose();
    _timer?.cancel();
  }

  sendMessage(String message) {
    socket!
        .emit("newChatMessage", {'body': '${message}', 'senderId': socket!.id});
  }

  void initializeSocket() {
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
    // socket!.on('newChatMessage', (data) {
    //   // print(data); //
    //   setState(() {
    //     _message = data;
    //     _datasocket = DataSocket.fromJson(jsonDecode(data));
    //   });
    //   // print(_datasocket);
    //   // print(_setledgreen);
    // });
    socket!.on('message', (data) {
      print(data); //
    });

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
        final config_id = commands.substring(
            commands.indexOf('=') + 1, commands.indexOf('|'));
        final values =
            commands.substring(commands.indexOf('|') + 1, commands.length);
        // if (atcommands.indexOf('AT+TOGGLE') != -1) {
        //   setState(() {
        //     status = (int.parse(values) == 0 ? false : true);
        //   });
        // }
        if (atcommands.indexOf('AT+MODE') != -1) {
          // เปลี่ยนโหมด
          print('เปลี่ยนโหมด ${values} config_id ${config_id}');
          setState(() {
            checkedIndex = int.parse(values);
          });
          sendUserMode(config_id);
        }
        print('atcommands = ${atcommands} & values = ${values}');
      }

      // print(_datasocket);
      // print(_setledgreen);
    });

    //listens when the client is disconnected from the Server
    socket!.on('disconnect', (data) {
      print('disconnect');
    });
  }

  sendUserMode(idMode) async {
    final body = {'user_modes': idMode.toString()};
    var res = await http.put(
        Uri.parse(
          'https://sttslife-api.sttslife.co/users/modes/${iduser}',
        ),
        body: body);
    if (res.statusCode == 200) {
      print('success ');
    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              'Mode ควบคุมการทำงาน',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[400]),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 150,
                child: GridView.builder(
                    itemCount: _dataModesList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 2.4),
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      bool checked = index == checkedIndex;
                      return Card(
                        elevation: 4,
                        // color: Colors.green[50],
                        color: checked ? Colors.green[400] : Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Mode',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${_dataModesList[index].configName}',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            // /#RT=user_id,modes_id$
                            FlatButton.icon(
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                print(
                                    'ตั้งค่าโหมดเป็น: #RT=${_dataModesList[index].configId}\$');
                                // sendMessage(
                                //     '#RT=${_dataModesList[index].configId}\$');
                                sendMessage(
                                    'AT+MODE=${_dataModesList[index].configId}|${index}');
                                sendUserMode(_dataModesList[index].configId);
                                //////put api
                                ///
                                setState(() {
                                  _Textmode = _dataModesList[index]
                                      .configName
                                      .toString();
                                  checkedIndex = index;
                                  // prefs.setString(
                                  //     'user_modes', index.toString());
                                });
                                print(checkedIndex);
                              },
                              icon: Icon(
                                Icons.settings_applications_outlined,
                                color: Colors.black,
                                size: 30,
                              ),
                              label: Text(''),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
