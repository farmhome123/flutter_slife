// To parse this JSON data, do
//
//     final dataSocket = dataSocketFromJson(jsonString);

import 'dart:convert';

DataSocket dataSocketFromJson(String str) =>
    DataSocket.fromJson(json.decode(str));

String dataSocketToJson(DataSocket data) => json.encode(data.toJson());

class DataSocket {
  DataSocket({
    required this.temperature,
    required this.ledyellow,
    required this.ledgreen,
    required this.ledred,
    required this.countred,
    required this.countyellow,
  });

  String temperature;
  String ledyellow;
  String ledgreen;
  String ledred;
  String countred;
  String countyellow;

  factory DataSocket.fromJson(Map<String, dynamic> json) => DataSocket(
        temperature: json["temperature"] == null ? null : json["temperature"],
        ledyellow: json["ledyellow"] == null ? null : json["ledyellow"],
        ledgreen: json["ledgreen"] == null ? null : json["ledgreen"],
        ledred: json["ledred"] == null ? null : json["ledred"],
        countred: json["countred"] == null ? null : json["countred"],
        countyellow: json["countyellow"] == null ? null : json["countyellow"],
      );

  Map<String, dynamic> toJson() => {
        "temperature": temperature == null ? null : temperature,
        "ledyellow": ledyellow == null ? null : ledyellow,
        "ledgreen": ledgreen == null ? null : ledgreen,
        "ledred": ledred == null ? null : ledred,
        "countred": countred == null ? null : countred,
        "countyellow": countyellow == null ? null : countyellow,
      };
}
