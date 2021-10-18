import 'dart:convert';

import 'package:time_entry_ui_examples/models/audit.dart';
import 'package:time_entry_ui_examples/preferences/preferences.dart';
import 'package:http/http.dart' as http;

class Webservice {
  Webservice();

  Future<int> fetchLocation(String email) async {
    try {
      final response = await http.get(Uri.parse(
          "http://${Preferences.webHost}:8080/DBCWebService/DBC/getlocation?email=$email"));
      int index = ["01", "02", "06", "09"].indexOf(response.body);
      if (index == -1) index = 0;
      return index;
    } on Exception {
      throw Exception("fetchLocation Timeout");
    }
  }

  Future<void> auditApp(Audit audit) async {
    print("Webservice.dart " + Preferences.webHost);
    try {
      await http
          .post(
        Uri.parse(
            "http://${Preferences.webHost}:8080/DBCWebService/DBC/auditapp"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(audit.toJson()),
      )
          .timeout(
        Duration(
          seconds: 5,
        ),
      );
    } catch (e) {
      print("Audit Timeout $e");
    }
  }

  Future<void> updateLocationCode(String locationCode) async {
    try {
      await http.post(
        Uri.parse(
            "http://${Preferences.webHost}:8080/DBCWebService/DBC/updatelocationcode?locationCode=$locationCode&email=${Preferences.currentEmail}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(
        Duration(
          seconds: 5,
        ),
      );
    } on Exception {
      throw Exception("Location Code Timeout");
    }
  }
}
