import 'dart:convert';
import 'dart:io';
import 'dart:html' as html;

import 'package:http/http.dart' show Response;
import 'package:http/browser_client.dart';

import 'models/user.dart';

class ApiException extends HttpException {
  final List<String> errors;
  ApiException(this.errors) : super(errors.join('\n'));
}

class ApiService {
  final String baseUrl;
  final BrowserClient client;

  ApiService(this.baseUrl) : client = BrowserClient()..withCredentials = true;

  bool get hasAuthCookie {
    final cookie = html.document.cookie;
    return cookie != null && cookie.contains('auth');
  }

  Uri getUri(String path) => Uri.parse('$baseUrl/api$path');

  void clearAuthCookie() => html.document.cookie = 'auth=' '';

  Future<User> getUser() async {
    try {
      final result = await client.get(getUri('/users/me'));
      handleErrorIfAny(result);

      final data = jsonDecode(result.body)['user'];
      return User.fromJson(data);
    } catch (e) {
      throw ApiException([e.toString()]);
    }
  }

  Future<User> loginUser(String email, String password) async {
    try {
      final result = await client.post(getUri('/auth/login'), body: {'email': email, 'password': password});
      handleErrorIfAny(result);

      final data = jsonDecode(result.body)['user'];
      return User.fromJson(data);
    } catch (e) {
      throw ApiException([e.toString()]);
    }
  }

  Future<bool> registerUser(String displayName, String email, String password) async {
    try {
      final result = await client
          .post(getUri('/auth/register'), body: {'name': displayName, 'email': email, 'password': password});
      handleErrorIfAny(result);
      return true;
    } catch (e) {
      throw ApiException([e.toString()]);
    }
  }

  void handleErrorIfAny(Response response) {
    if (response.statusCode == HttpStatus.ok) return;
    final errors = jsonDecode(response.body)['errors'] as Iterable<String>;
    throw ApiException(errors.toList());
  }
}
