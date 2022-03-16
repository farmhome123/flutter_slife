// To parse this JSON data, do
//
//     final dataStateUser = dataStateUserFromJson(jsonString);

import 'dart:convert';

DataStateUser dataStateUserFromJson(String str) =>
    DataStateUser.fromJson(json.decode(str));

String dataStateUserToJson(DataStateUser data) => json.encode(data.toJson());

class DataStateUser {
  DataStateUser({
    required this.err,
    required this.status,
    required this.message,
  });

  bool err;
  bool status;
  List<Message> message;

  factory DataStateUser.fromJson(Map<String, dynamic> json) => DataStateUser(
        err: json["err"],
        status: json["status"],
        message:
            List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "err": err,
        "status": status,
        "message": List<dynamic>.from(message.map((x) => x.toJson())),
      };
}

class Message {
  Message({
    required this.userId,
    required this.userEnable,
    required this.userUsername,
    required this.userPassword,
    required this.userDetail,
    required this.userLocaltion,
    required this.userType,
    required this.airSpecies,
    required this.userPurchaseorder,
    required this.userTel,
    required this.userUpdatetimes,
    required this.userCreatetimes,
    required this.airBrand,
    required this.airBtu,
    required this.airType,
    required this.airLifetime,
    required this.userStartwaranty,
    required this.userEndwaranty,
    required this.userModes,
    required this.userPulseset,
    required this.nightmode,
    required this.sleepmode,
    required this.logo,
  });

  int userId;
  int userEnable;
  String userUsername;
  String userPassword;
  String userDetail;
  String userLocaltion;
  String userType;
  String airSpecies;
  String userPurchaseorder;
  String userTel;
  DateTime userUpdatetimes;
  DateTime userCreatetimes;
  String airBrand;
  String airBtu;
  String airType;
  String airLifetime;
  DateTime userStartwaranty;
  DateTime userEndwaranty;
  int userModes;
  int userPulseset;
  int nightmode;
  int sleepmode;
  int logo;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        userId: json["user_id"],
        userEnable: json["user_enable"],
        userUsername: json["user_username"],
        userPassword: json["user_password"],
        userDetail: json["user_detail"],
        userLocaltion: json["user_localtion"],
        userType: json["user_type"],
        airSpecies: json["air_species"],
        userPurchaseorder: json["user_purchaseorder"],
        userTel: json["user_tel"],
        userUpdatetimes: DateTime.parse(json["user_updatetimes"]),
        userCreatetimes: DateTime.parse(json["user_createtimes"]),
        airBrand: json["air_brand"],
        airBtu: json["air_btu"],
        airType: json["air_type"],
        airLifetime: json["air_lifetime"],
        userStartwaranty: DateTime.parse(json["user_startwaranty"]),
        userEndwaranty: DateTime.parse(json["user_endwaranty"]),
        userModes: json["user_modes"],
        userPulseset: json["user_pulseset"],
        nightmode: json["nightmode"],
        sleepmode: json["sleepmode"],
        logo: json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_enable": userEnable,
        "user_username": userUsername,
        "user_password": userPassword,
        "user_detail": userDetail,
        "user_localtion": userLocaltion,
        "user_type": userType,
        "air_species": airSpecies,
        "user_purchaseorder": userPurchaseorder,
        "user_tel": userTel,
        "user_updatetimes": userUpdatetimes.toIso8601String(),
        "user_createtimes": userCreatetimes.toIso8601String(),
        "air_brand": airBrand,
        "air_btu": airBtu,
        "air_type": airType,
        "air_lifetime": airLifetime,
        "user_startwaranty":
            "${userStartwaranty.year.toString().padLeft(4, '0')}-${userStartwaranty.month.toString().padLeft(2, '0')}-${userStartwaranty.day.toString().padLeft(2, '0')}",
        "user_endwaranty":
            "${userEndwaranty.year.toString().padLeft(4, '0')}-${userEndwaranty.month.toString().padLeft(2, '0')}-${userEndwaranty.day.toString().padLeft(2, '0')}",
        "user_modes": userModes,
        "user_pulseset": userPulseset,
        "nightmode": nightmode,
        "sleepmode": sleepmode,
        "logo": logo,
      };
}
