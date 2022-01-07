// To parse this JSON data, do
//
//     final dataModes = dataModesFromJson(jsonString);

import 'dart:convert';

DataModes dataModesFromJson(String str) => DataModes.fromJson(json.decode(str));

String dataModesToJson(DataModes data) => json.encode(data.toJson());

class DataModes {
  DataModes({
    required this.err,
    required this.status,
    required this.message,
  });

  final bool err;
  final bool status;
  final List<Message>? message;

  factory DataModes.fromJson(Map<String, dynamic> json) => DataModes(
        err: json["err"] == null ? null : json["err"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null
            ? null
            : List<Message>.from(
                json["message"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "err": err == null ? null : err,
        "status": status == null ? null : status,
        "message": message == null
            ? null
            : List<dynamic>.from(message!.map((x) => x.toJson())),
      };
}

class Message {
  Message({
    required this.configId,
    required this.userId,
    required this.configSlope,
    required this.configTempcutoff,
    required this.configTempleak,
    required this.configTimeleak,
    required this.configTime1,
    required this.configTime2,
    required this.configTime3,
    required this.configSleep,
    required this.configPulsecount,
    required this.configName,
    required this.configUpdatetime,
  });

  final int configId;
  final int userId;
  final double configSlope;
  final int configTempcutoff;
  final int configTempleak;
  final int configTimeleak;
  final int configTime1;
  final int configTime2;
  final int configTime3;
  final int configSleep;
  final int configPulsecount;
  final String configName;
  final DateTime configUpdatetime;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        configId: json["config_id"] == null ? null : json["config_id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        configSlope: json["config_slope"] == null
            ? null
            : json["config_slope"].toDouble(),
        configTempcutoff: json["config_tempcutoff"] == null
            ? null
            : json["config_tempcutoff"],
        configTempleak:
            json["config_templeak"] == null ? null : json["config_templeak"],
        configTimeleak:
            json["config_timeleak"] == null ? null : json["config_timeleak"],
        configTime1: json["config_time1"] == null ? null : json["config_time1"],
        configTime2: json["config_time2"] == null ? null : json["config_time2"],
        configTime3: json["config_time3"] == null ? null : json["config_time3"],
        configSleep: json["config_sleep"] == null ? null : json["config_sleep"],
        configPulsecount: json["config_pulsecount"] == null
            ? null
            : json["config_pulsecount"],
        configName: json["config_name"] == null ? null : json["config_name"],
        configUpdatetime: DateTime.parse(json["config_updatetime"]),
      );

  Map<String, dynamic> toJson() => {
        "config_id": configId == null ? null : configId,
        "user_id": userId == null ? null : userId,
        "config_slope": configSlope == null ? null : configSlope,
        "config_tempcutoff": configTempcutoff == null ? null : configTempcutoff,
        "config_templeak": configTempleak == null ? null : configTempleak,
        "config_timeleak": configTimeleak == null ? null : configTimeleak,
        "config_time1": configTime1 == null ? null : configTime1,
        "config_time2": configTime2 == null ? null : configTime2,
        "config_time3": configTime3 == null ? null : configTime3,
        "config_sleep": configSleep == null ? null : configSleep,
        "config_pulsecount": configPulsecount == null ? null : configPulsecount,
        "config_name": configName == null ? null : configName,
        "config_updatetime": configUpdatetime == null
            ? null
            : configUpdatetime.toIso8601String(),
      };
}
