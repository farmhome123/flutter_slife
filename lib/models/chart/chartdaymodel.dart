// To parse this JSON data, do
//
//     final chartDayModel = chartDayModelFromJson(jsonString);

import 'dart:convert';

ChartDayModel chartDayModelFromJson(String str) => ChartDayModel.fromJson(json.decode(str));

String chartDayModelToJson(ChartDayModel data) => json.encode(data.toJson());

class ChartDayModel {
    ChartDayModel({
     required   this.err,
    required    this.status,
     required   this.message,
    });

    bool err;
    bool status;
    List<Message> message;

    factory ChartDayModel.fromJson(Map<String, dynamic> json) => ChartDayModel(
        err: json["err"],
        status: json["status"],
        message: List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "err": err,
        "status": status,
        "message": List<dynamic>.from(message.map((x) => x.toJson())),
    };
}

class Message {
    Message({
     required   this.datalogId,
     required   this.userId,
     required   this.datalogCount,
     required   this.datalogTempavg,
     required   this.datalogTime,
    });

    int datalogId;
    int userId;
    int datalogCount;
    double datalogTempavg;
    DateTime datalogTime;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        datalogId: json["datalog_id"],
        userId: json["user_id"],
        datalogCount: json["datalog_count"],
        datalogTempavg: json["datalog_tempavg"].toDouble(),
        datalogTime: DateTime.parse(json["datalog_time"]),
    );

    Map<String, dynamic> toJson() => {
        "datalog_id": datalogId,
        "user_id": userId,
        "datalog_count": datalogCount,
        "datalog_tempavg": datalogTempavg,
        "datalog_time": datalogTime.toIso8601String(),
    };
}
