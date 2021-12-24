import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_contron/models/datalog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LogScreen extends StatefulWidget {
  const LogScreen({Key? key}) : super(key: key);

  @override
  _LogScreenState createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  DateTime selectedDate = DateTime.now();
  DataLog? _datalog;
  // List? _dataDay;
  // String? _myStateDay = _datalog?.message[0].datalogTime;
  Future<void> getuser() async {
    String? iduser;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await http.get(Uri.parse(
        "https://sttslife-api.sttslife.co/datalog/" +
            prefs.getString('userId').toString()));
    // var data = json.decode(res.body);

    setState(() {
      _datalog = dataLogFromJson(res.body);
      iduser = prefs.getString('userId');
    });
    print(_datalog!.message);
    // print(_datalog!.message[0].userId);
    // print('iduser = ${iduser}');
    // print('index = ${_datalog!.message.length}');
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "${selectedDate.toLocal()}".split(' ')[0],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  onPressed: () => _selectDate(context), // Refer step 3
                  child: Text(
                    'เลือกวันที่',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  color: Colors.blue[400],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Text(
                    'ข้อมูลย้อนหลัง',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _datalog?.message.length != null
                      ? ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _datalog!.message.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                height: MediaQuery.of(context).size.height / 5,
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Color(0xFFF105BCF)),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color(0xFF105BCF).withOpacity(0.4),
                                        spreadRadius: 4,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                    borderRadius: new BorderRadius.only(
                                      topRight: const Radius.circular(30),
                                      topLeft: const Radius.circular(30),
                                      bottomLeft: const Radius.circular(30),
                                      bottomRight: const Radius.circular(30),
                                    )),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 30),
                                      child: Row(
                                        children: [
                                          Text(
                                            'อุณหภูมิเฉลี่ย  ',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF493a3a),
                                            ),
                                          ),
                                          Text(
                                            '${_datalog?.message[index].datalogTempavg}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF493a3a),
                                            ),
                                          ),
                                          Text(
                                            ' °C',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF493a3a),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 30),
                                      child: Row(
                                        children: [
                                          Text(
                                            'จำนวนการทำงาน  ',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF493a3a),
                                            ),
                                          ),
                                          Text(
                                            '${_datalog?.message[index].datalogCount}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF493a3a),
                                            ),
                                          ),
                                          Text(
                                            '  ครั้ง',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF493a3a),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 30),
                                      child: Row(
                                        children: [
                                          // Text(
                                          //   'Time log = ',
                                          //   style: TextStyle(
                                          //     fontSize: 16,
                                          //     fontWeight: FontWeight.bold,
                                          //     color: Color(0xFF493a3a),
                                          //   ),
                                          // ),
                                          // Text(
                                          //   '${_datalog[index]['datalog_time']}',
                                          //   style: TextStyle(
                                          //     fontSize: 16,
                                          //     fontWeight: FontWeight.bold,
                                          //     color: Color(0xFF493a3a),
                                          //   ),
                                          // ),
                                          Text(
                                            DateFormat('วันที่ ' +
                                                    'dd-MM-yyyy' +
                                                    ' น.')
                                                .format(_datalog!.message[index]
                                                    .datalogTime),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF493a3a),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 120,
                            ),
                            Center(
                              child: SpinKitFadingCircle(
                                duration: Duration(milliseconds: 2000),
                                color: Colors.blue,
                                size: 50.0,
                              ),
                            ),
                          ],
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
