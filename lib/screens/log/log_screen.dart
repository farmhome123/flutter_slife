import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contron/models/chart/chartdaymodel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class LogScreen extends StatefulWidget {
  const LogScreen({Key? key}) : super(key: key);

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  List<SalesDetails> sales = [];
  ChartDayModel? _chartDayModel;

  int sum_count = 0;
  double sum_avg = 0;
  DateTime? _dateTimeSeleceted;
  void loadSalesData() {
    sum_count = 0;
    sum_avg = 0;
    sales.clear();
    for (var item in _chartDayModel!.message) {
      sales.add(SalesDetails(
          //  DateFormat('yyyy-MM-dd – kk:mm').format(item.datalogTime).toString(),
          DateFormat('HH:mm').format(item.datalogTime).toString(),
          item.datalogTempavg.toString(),
          item.datalogCount.toString()));
      sum_count = sum_count + item.datalogCount;
      sum_avg = sum_avg + item.datalogTempavg;
    }
    setState(() {});
  }

  Future<void> getDataDay(dateTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userid = await prefs.getString('userId').toString();
    final data = {"date": "${dateTime}"};
    print('data ===> $data');
    final url =
        Uri.parse("https://sttslife-api.sttslife.co/datalog/date/date/$userid");
    try {
      var res = await http.post(url, body: data);
      if (res.statusCode == 200) {
        setState(() {
          _chartDayModel = chartDayModelFromJson(res.body);
        });
        print(jsonEncode(_chartDayModel!.message));
        loadSalesData();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    sales.clear();
    super.dispose();
  }

  DateTime timeBackPressed = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWaring = difference >= Duration(seconds: 2);
        if (isExitWaring) {
          final message = 'Press back again to exit';
          Fluttertoast.showToast(msg: message, fontSize: 18);
          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.green,
        //   title: const Text('ข้อมูลย้อนหลัง'),
        //   centerTitle: true,
        // ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                'ข้อมูลย้อนหลัง',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              SelectDay(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ข้อมูลวันที่: '),
                  Text(_dateTimeSeleceted != null
                      ? '${DateFormat('dd-MM-yyyy').format(_dateTimeSeleceted!).toString()}'
                      : 'คุณยังไม่ได้เลือกวันที่'),
                ],
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('จำนวนครั้ง = $sum_count'),
                  // _chartDayModel != null
                  //     ? Text(
                  //         'AVG = ${(sum_avg / _chartDayModel!.message.length).toStringAsFixed(2)}')
                  //     : Text('AVG = 0'),
                  _chartDayModel != null
                      ? Text(_chartDayModel!.message.length > 0
                          ? 'อุณหภูมิเฉลี่ย = ${(sum_avg / _chartDayModel!.message.length).toStringAsFixed(2)}'
                          : 'อุณหภูมิเฉลี่ย = 0')
                      : Text('อุณหภูมิเฉลี่ย = 0'),
                ],
              ),
              Divider(
                thickness: 1,
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: SizedBox(
                    height: 40,
                    child: _chartDayModel == null
                        ? Text(
                            'ไม่มีข้อมูล',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          )
                        : Text(
                            _chartDayModel!.message.length < 1
                                ? 'ไม่มีข้อมูล'
                                : '',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                  )),
              _buildChart(
                sales: sales,
                dateTimeSeleceted: _dateTimeSeleceted.toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding SelectDay() => Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  initialDate: DateTime.now(),
                ).then(
                  (value) {
                    if (value != null) {
                      setState(() {
                        _dateTimeSeleceted = value;
                      });
                      print("value ==> $value");
                      getDataDay(value);
                    }
                  },
                );
              },
              child: Row(
                children: [
                  Text(
                    'เลือกวันที่',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.date_range,
                    color: Colors.green,
                    size: 24,
                  )
                ],
              ),
            ),
            // Text('Weak'),
            // Text('Month'),
            // Text('Year'),
          ],
        ),
      );
}

class _buildChart extends StatelessWidget {
  const _buildChart({
    Key? key,
    required this.sales,
    required this.dateTimeSeleceted,
  }) : super(key: key);
  final String dateTimeSeleceted;
  final List<SalesDetails> sales;

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

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showWarning(context);
        return shouldPop ?? false;
      },
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.width * 0.7,
          width: MediaQuery.of(context).size.width,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
                labelRotation: 90, labelStyle: TextStyle(fontSize: 10)),
            enableSideBySideSeriesPlacement: false,
            series: [
              LineSeries<SalesDetails, String>(
                dataSource: sales,
                xValueMapper: (SalesDetails details, _) => details.month,
                yValueMapper: (SalesDetails details, _) =>
                    double.parse(details.salesCount),
                width: 3, opacity: 0.9,
                // spacing: 0.2,
                name: 'จำนวนครั้ง',
                enableTooltip: true,
                markerSettings: MarkerSettings(isVisible: true),
              ),
              LineSeries<SalesDetails, String>(
                dataSource: sales,
                xValueMapper: (SalesDetails details, _) => details.month,
                yValueMapper: (SalesDetails details, _) =>
                    int.parse(details.salesavg),
                opacity: 0.9,
                width: 3,
                name: 'อุณหภูมิเฉลี่ย',
                enableTooltip: true,
                markerSettings: MarkerSettings(isVisible: true),
              ),
            ],
            tooltipBehavior: TooltipBehavior(
                enable: true,
                canShowMarker: false,
                header: '',
                format: 'point.y marks in point.x'),
            legend: Legend(isVisible: true, position: LegendPosition.bottom),
          ),
        ),
      ),
    );
  }

  void showDatePicker(context) {
    showDialog(
      context: context,
      builder: (context) => DateTimePicker(
        initialValue: DateTime.now().toString(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        dateLabelText: 'Date',
        onChanged: (val) => print(val),
        validator: (val) {
          print(val);
          return null;
        },
        onSaved: (val) => print(val),
      ),
    );
  }
}

class SalesDetails {
  final String month;
  final String salesCount;
  final String salesavg;
  SalesDetails(this.month, this.salesCount, this.salesavg);
}
