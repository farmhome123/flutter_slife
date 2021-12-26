// To parse this JSON data, do
//
//     final dataDay = dataDayFromJson(jsonString);

import 'dart:convert';

List<DataDay> dataDayFromJson(String str) =>
    List<DataDay>.from(json.decode(str).map((x) => DataDay.fromJson(x)));

String dataDayToJson(List<DataDay> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DataDay {
  DataDay({
    required this.datalogId,
    required this.userId,
    required this.datalogCount,
    required this.datalogTempavg,
    required this.datalogTime,
  });

  int datalogId;
  int userId;
  int datalogCount;
  double datalogTempavg;
  String datalogTime;

  factory DataDay.fromJson(Map<String, dynamic> json) => DataDay(
        datalogId: json["datalog_id"] == null ? null : json["datalog_id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        datalogCount:
            json["datalog_count"] == null ? null : json["datalog_count"],
        datalogTempavg: json["datalog_tempavg"] == null
            ? null
            : json["datalog_tempavg"].toDouble(),
        datalogTime: json["datalog_time"],
      );

  Map<String, dynamic> toJson() => {
        "datalog_id": datalogId == null ? null : datalogId,
        "user_id": userId == null ? null : userId,
        "datalog_count": datalogCount == null ? null : datalogCount,
        "datalog_tempavg": datalogTempavg == null ? null : datalogTempavg,
        "datalog_time": datalogTime == null ? null : datalogTime,
      };
}
