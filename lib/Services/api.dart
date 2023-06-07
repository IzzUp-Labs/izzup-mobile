import 'package:http/http.dart' as http;

import 'string_to_bool.dart';

class Api {
  static const _baseRoute = 'http://10.33.0.184:3000/api/v1/';

  static _getUri(String route) {
    return Uri.parse(_baseRoute + route);
  }

  static Future<bool?> authCheck(String email) async {
    var client = http.Client();
    try {
      var response =
          await client.post(_getUri('auth/check'), body: {'email': email});
      return response.body.toBoolean();
    } finally {
      client.close();
    }
  }
}
