// To parse this JSON data, do
//
//     final dataSocket = dataSocketFromJson(jsonString);

import 'dart:convert';

DataSocket dataSocketFromJson(String str) =>
    DataSocket.fromJson(json.decode(str));

String dataSocketToJson(DataSocket data) => json.encode(data.toJson());

class DataSocket {
  DataSocket({
    required this.userId,
    required this.ledr,
    required this.ledy,
    required this.ledg,
    required this.countred,
    required this.countyellow,
    required this.temp,
    required this.avgt,
    required this.slope,
    required this.minT,
    required this.maxT,
    required this.t,
    required this.pulse,
    required this.sleeps,
    required this.modeId,
  });

  String userId;
  String ledr;
  String ledy;
  String ledg;
  String countred;
  String countyellow;
  String temp;
  String avgt;
  String slope;
  String minT;
  String maxT;
  String t;
  String pulse;
  String sleeps;
  String modeId;

  factory DataSocket.fromJson(Map<String, dynamic> json) => DataSocket(
        userId: json["user_id"] == null ? null : json["user_id"],
        ledr: json["ledr"] == null ? null : json["ledr"],
        ledy: json["ledy"] == null ? null : json["ledy"],
        ledg: json["ledg"] == null ? null : json["ledg"],
        countred: json["countred"] == null ? null : json["countred"],
        countyellow: json["countyellow"] == null ? null : json["countyellow"],
        temp: json["temp"] == null ? null : json["temp"],
        avgt: json["avgt"] == null ? null : json["avgt"],
        slope: json["slope"] == null ? null : json["slope"],
        minT: json["minT"] == null ? null : json["minT"],
        maxT: json["maxT"] == null ? null : json["maxT"],
        t: json["t"] == null ? null : json["t"],
        pulse: json["pulse"] == null ? null : json["pulse"],
        sleeps: json["sleeps"] == null ? null : json["sleeps"],
        modeId: json["mode_id"] == null ? null : json["mode_id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId == null ? null : userId,
        "ledr": ledr == null ? null : ledr,
        "ledy": ledy == null ? null : ledy,
        "ledg": ledg == null ? null : ledg,
        "countred": countred == null ? null : countred,
        "countyellow": countyellow == null ? null : countyellow,
        "temp": temp == null ? null : temp,
        "avgt": avgt == null ? null : avgt,
        "slope": slope == null ? null : slope,
        "minT": minT == null ? null : minT,
        "maxT": maxT == null ? null : maxT,
        "t": t == null ? null : t,
        "pulse": pulse == null ? null : pulse,
        "sleeps": sleeps == null ? null : sleeps,
        "mode_id": modeId == null ? null : modeId,
      };
}
