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

  final bool err;
  final bool status;
  final List<Message>? message;

  factory DataStateUser.fromJson(Map<String, dynamic> json) => DataStateUser(
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
  });

  final int userId;
  final int userEnable;
  final String userUsername;
  final String userPassword;
  final String userDetail;
  final String userLocaltion;
  final String userType;
  final String airSpecies;
  final String userPurchaseorder;
  final String userTel;
  final DateTime userUpdatetimes;
  final DateTime userCreatetimes;
  final String airBrand;
  final String airBtu;
  final String airType;
  final String airLifetime;
  final DateTime userStartwaranty;
  final DateTime userEndwaranty;
  final int userModes;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        userId: json["user_id"] == null ? null : json["user_id"],
        userEnable: json["user_enable"] == null ? null : json["user_enable"],
        userUsername:
            json["user_username"] == null ? null : json["user_username"],
        userPassword:
            json["user_password"] == null ? null : json["user_password"],
        userDetail: json["user_detail"] == null ? null : json["user_detail"],
        userLocaltion:
            json["user_localtion"] == null ? null : json["user_localtion"],
        userType: json["user_type"] == null ? null : json["user_type"],
        airSpecies: json["air_species"] == null ? null : json["air_species"],
        userPurchaseorder: json["user_purchaseorder"] == null
            ? null
            : json["user_purchaseorder"],
        userTel: json["user_tel"] == null ? null : json["user_tel"],
        userUpdatetimes: DateTime.parse(json["user_updatetimes"]),
        userCreatetimes: DateTime.parse(json["user_createtimes"]),
        airBrand: json["air_brand"] == null ? null : json["air_brand"],
        airBtu: json["air_btu"] == null ? null : json["air_btu"],
        airType: json["air_type"] == null ? null : json["air_type"],
        airLifetime: json["air_lifetime"] == null ? null : json["air_lifetime"],
        userStartwaranty: DateTime.parse(json["user_startwaranty"]),
        userEndwaranty: DateTime.parse(json["user_endwaranty"]),
        userModes: json["user_modes"] == null ? null : json["user_modes"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId == null ? null : userId,
        "user_enable": userEnable == null ? null : userEnable,
        "user_username": userUsername == null ? null : userUsername,
        "user_password": userPassword == null ? null : userPassword,
        "user_detail": userDetail == null ? null : userDetail,
        "user_localtion": userLocaltion == null ? null : userLocaltion,
        "user_type": userType == null ? null : userType,
        "air_species": airSpecies == null ? null : airSpecies,
        "user_purchaseorder":
            userPurchaseorder == null ? null : userPurchaseorder,
        "user_tel": userTel == null ? null : userTel,
        "user_updatetimes":
            userUpdatetimes == null ? null : userUpdatetimes.toIso8601String(),
        "user_createtimes":
            userCreatetimes == null ? null : userCreatetimes.toIso8601String(),
        "air_brand": airBrand == null ? null : airBrand,
        "air_btu": airBtu == null ? null : airBtu,
        "air_type": airType == null ? null : airType,
        "air_lifetime": airLifetime == null ? null : airLifetime,
        "user_startwaranty": userStartwaranty == null
            ? null
            : "${userStartwaranty.year.toString().padLeft(4, '0')}-${userStartwaranty.month.toString().padLeft(2, '0')}-${userStartwaranty.day.toString().padLeft(2, '0')}",
        "user_endwaranty": userEndwaranty == null
            ? null
            : "${userEndwaranty.year.toString().padLeft(4, '0')}-${userEndwaranty.month.toString().padLeft(2, '0')}-${userEndwaranty.day.toString().padLeft(2, '0')}",
        "user_modes": userModes == null ? null : userModes,
      };
}
