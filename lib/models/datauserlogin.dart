// To parse this JSON data, do
//
//     final dataUser = dataUserFromJson(jsonString);

import 'dart:convert';

DataUser dataUserFromJson(String str) => DataUser.fromJson(json.decode(str));

String dataUserToJson(DataUser data) => json.encode(data.toJson());

class DataUser {
  DataUser({
    required this.err,
    required this.message,
  });

  bool err;
  List<Message> message;

  factory DataUser.fromJson(Map<String, dynamic> json) => DataUser(
        err: json["err"],
        message:
            List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "err": err,
        "message": List<dynamic>.from(message.map((x) => x.toJson())),
      };
}

class Message {
  Message({
    required this.userId,
    required this.userUsername,
    required this.userPassword,
    required this.userDetail,
    required this.userLocaltion,
    required this.userType,
    required this.userPurchaseorder,
    required this.userTel,
    required this.userUpdatetimes,
    required this.userCreatetimes,
    required this.airBrand,
    required this.airBtu,
    required this.airType,
    required this.airLifetime,
  });

  int userId;
  String userUsername;
  String userPassword;
  String userDetail;
  String userLocaltion;
  String userType;
  String userPurchaseorder;
  String userTel;
  DateTime userUpdatetimes;
  DateTime userCreatetimes;
  String airBrand;
  String airBtu;
  String airType;
  String airLifetime;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        userId: json["user_id"],
        userUsername: json["user_username"],
        userPassword: json["user_password"],
        userDetail: json["user_detail"],
        userLocaltion: json["user_localtion"],
        userType: json["user_type"],
        userPurchaseorder: json["user_purchaseorder"],
        userTel: json["user_tel"],
        userUpdatetimes: DateTime.parse(json["user_updatetimes"]),
        userCreatetimes: DateTime.parse(json["user_createtimes"]),
        airBrand: json["air_brand"],
        airBtu: json["air_btu"],
        airType: json["air_type"],
        airLifetime: json["air_lifetime"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_username": userUsername,
        "user_password": userPassword,
        "user_detail": userDetail,
        "user_localtion": userLocaltion,
        "user_type": userType,
        "user_purchaseorder": userPurchaseorder,
        "user_tel": userTel,
        "user_updatetimes": userUpdatetimes.toIso8601String(),
        "user_createtimes": userCreatetimes.toIso8601String(),
        "air_brand": airBrand,
        "air_btu": airBtu,
        "air_type": airType,
        "air_lifetime": airLifetime,
      };
}
