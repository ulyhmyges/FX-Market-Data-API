import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pricer_app/models/Session.dart';
import '../models/user.dart';

class UserService {
  final String baseURL;

  UserService({required this.baseURL});

  Future<String> login(User user) async {
    final uri = Uri.parse('$baseURL/login');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJSON())
    );
    if (res.statusCode == 200 ){
      final json = jsonDecode(res.body);
      final token = json['token'];
      return token;
    } else {
      throw Exception('Failed to login: ${res.statusCode}');
    }
  }

  Future<bool> subscribe(User user) async {
    final uri = Uri.parse('$baseURL/subscribe');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJSON())
    );
    if (res.statusCode == 201) {
      final json = jsonDecode(res.body);
      return true;
    } else {
      throw Exception('User already exists: ${res.statusCode}');
    }
  }

  Future<Session> me(String token) async {
    final uri = Uri.parse('$baseURL/me');
    final res = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'}
    );
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final Session session = Session.fromJSON(json);
      return session;
    } else {
      throw Exception('Not Authorized ${res.statusCode}');
    }
  }


}