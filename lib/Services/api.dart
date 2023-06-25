import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:izzup/Models/employer.dart';
import 'package:izzup/Models/globals.dart';
import 'package:izzup/Services/prefs.dart';

import '../Models/extra.dart';
import 'string_to_bool.dart';

class Api {
  static const _baseRoute = 'https://izzup-api-production.up.railway.app/api/v1/';

  static _getUri(String route) {
    return Uri.parse(_baseRoute + route);
  }

  static Future<bool?> authCheck(String email) async {
    var client = http.Client();
    try {
      var response = await client.post(_getUri('auth/check'), body: {
        'email': email
      });
      return response.body.toBoolean();
    } finally {
      client.close();
    }
  }

  static Future<int> _registerExtra(Extra extra) async {
    var client = http.Client();
    try {
      var response = await client.post(_getUri('auth/register/extra'), body: {
        "email": extra.email,
        "password": extra.password,
        "last_name": extra.lastName,
        "first_name": extra.firstName,
        "date_of_birth": extra.dateOfBirth.dateString,
        "address": extra.address
      });
      return response.statusCode;
    } finally {
      client.close();
    }
  }

  static Future<int> _registerEmployer(Employer employer) async {
    var client = http.Client();
    Map data = {
      "email": employer.email,
      "password": employer.password,
      "last_name": employer.lastName,
      "first_name": employer.firstName,
      "date_of_birth": employer.dateOfBirth.dateString,
      "company": {
        "name": employer.company.name,
        "address": employer.company.address
      }
    };
    print(json.encode(data));
    try {
      var response = await client.post(
          _getUri('auth/register/employer'),
          headers: {"Content-Type": "application/json"},
          body: json.encode(data)
      );
      return response.statusCode;
    } finally {
      client.close();
    }
  }

  static Future<bool> registerAndLoginExtra() async {
    int registerStatusCode = await _registerExtra(Globals.tempExtra);
    if (kDebugMode) {
      print(registerStatusCode);
    }
    return await login(Globals.tempExtra);
  }

  static Future<bool> registerAndLoginEmployer() async {
    int registerStatusCode = await _registerEmployer(Globals.tempEmployer);
    if (kDebugMode) {
      print(registerStatusCode);
    }
    return await login(Extra(Globals.tempEmployer.email, Globals.tempEmployer.password, DateTime.now()));
  }

  static Future<Map<String, dynamic>> _login(Extra extra) async {
    var client = http.Client();
    try {
      var response = await client.post(_getUri('auth/login'), body: {
        "email": extra.email,
        "password": extra.password
      });
      return jsonDecode(response.body);
    } finally {
      client.close();
    }
  }

  static Future<bool> login(Extra extra) async {
    Map<String, dynamic> loginResult = await _login(extra);
    if (loginResult.keys.contains('token')) {
      if (kDebugMode) print("Token updated");
      Prefs.setString('authToken', loginResult['token']);
      return true;
    } else {
      return false;
    }
  }
}
