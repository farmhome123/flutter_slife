import 'dart:convert';

import 'package:flutter_contron/models/datauserlogin.dart';
import 'package:http/http.dart' as http;

class CallAPI {
  _setHeaders() =>
      {"Content-Type": "application/json", 'Accept': 'application/json'};

  final baseAPIURL = Uri.parse('https://sttslife-api.sttslife.co/login');
  // Login API
  loginAPI(data) async {
    return await http.post(
      baseAPIURL,
      body: data,
      headers: _setHeaders(),
    );
  }

  // Read User Profile
  Future<DataUser?> getProfile(data) async {
    final response = await http.post(baseAPIURL,
        body: jsonEncode(data), headers: _setHeaders());
    if (response.statusCode == 200) {
      return dataUserFromJson(response.body);
    } else {
      return null;
    }
  }
}
