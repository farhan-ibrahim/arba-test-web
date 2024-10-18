import 'dart:convert';

import 'package:arba_test_web/src/model/user.dart';
import 'package:arba_test_web/src/repositories/api.dart';

class AuthRepository {
  final client = API();

  Future<User?> login(String email, String password) async {
    try {
      final body = <String, String>{
        'email': email,
        'password': password,
      };
      final response = await client.post("login", body);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body)["data"];
        final user = User.fromJson(data);
        return user;
      } else {
        throw '${jsonDecode(response.body)["message"]}';
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<User?> register(String email, String password, String name) async {
    try {
      final body = <String, String>{
        'email': email,
        'password': password,
        'name': name,
      };
      final response = await client.post("register", body);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body)["data"];
        final user = User.fromJson(data);
        return user;
      } else {
        throw '${jsonDecode(response.body)["message"]}';
      }
    } catch (e) {
      throw Exception('Register failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      await client.post("logout");
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}
