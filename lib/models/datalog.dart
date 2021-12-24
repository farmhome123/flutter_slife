// To parse this JSON data, do
//
//     final dataLog = dataLogFromJson(jsonString);

import 'dart:convert';

DataLog dataLogFromJson(String str) => DataLog.fromJson(json.decode(str));

String dataLogToJson(DataLog data) => json.encode(data.toJson());

class DataLog {
  DataLog({
    required this.message,
  });

  List<Message> message;

  factory DataLog.fromJson(Map<String, dynamic> json) => DataLog(
        message:
            List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message == null
            ? null
            : List<dynamic>.from(message.map((x) => x.toJson())),
      };
}

class Message {
  Message({
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
  DateTime datalogTime;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        datalogId: json["datalog_id"] == null ? null : json["datalog_id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        datalogCount:
            json["datalog_count"] == null ? null : json["datalog_count"],
        datalogTempavg: json["datalog_tempavg"] == null
            ? null
            : json["datalog_tempavg"].toDouble(),
        datalogTime: DateTime.parse(json["datalog_time"]),
      );

  Map<String, dynamic> toJson() => {
        "datalog_id": datalogId == null ? null : datalogId,
        "user_id": userId == null ? null : userId,
        "datalog_count": datalogCount == null ? null : datalogCount,
        "datalog_tempavg": datalogTempavg == null ? null : datalogTempavg,
        "datalog_time":
            datalogTime == null ? null : datalogTime.toIso8601String(),
      };
}
