import 'dart:convert';
import 'dart:developer';

import 'package:arba_test_web/src/repositories/config.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

const address = Config.apiURL;

class API {
  Future<Response> get(String path) async {
    try {
      final url = Uri.parse("$address/$path");
      log("Make request from $url");

      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });

      log("Response status: ${response.statusCode}");
      return response;
    } catch (e) {
      log("Error: $e");
      throw Exception('Bad request');
    }
  }

  Future<Response> post(String path,
      [Map<String, dynamic>? body, String? token]) async {
    try {
      final url = Uri.parse("$address/$path");
      log("Make request from $url");

      final headers = <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        "Content-type": "application/json"
      };

      if (token != null) {
        headers["Authorization"] = token;
      }

      final response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      log("Response status: ${response.statusCode}");
      return response;
    } catch (e) {
      log("Error: $e");
      throw Exception('Bad request: $e');
    }
  }
}
