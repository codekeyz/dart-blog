import 'dart:async';
import 'dart:convert';
import 'dart:io';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:http/http.dart' show Response;
import 'package:http/browser_client.dart';

import 'models/user.dart';

class ApiException extends HttpException {
  final Iterable<String> errors;
  ApiException(this.errors) : super(errors.join('\n'));
}

typedef HttpResponseCb = Future<Response> Function();

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
    final result = await _runCatching(() => client.get(getUri('/users/me')));

    final data = jsonDecode(result.body)['user'];
    return User.fromJson(data);
  }

  Future<User> loginUser(String email, String password) async {
    final result =
        await _runCatching(() => client.post(getUri('/auth/login'), body: {'email': email, 'password': password}));

    final data = jsonDecode(result.body)['user'];
    return User.fromJson(data);
  }

  Future<bool> registerUser(String displayName, String email, String password) async {
    await _runCatching(
        () => client.post(getUri('/auth/register'), body: {'name': displayName, 'email': email, 'password': password}));

    return true;
  }

  Future<Response> _runCatching(HttpResponseCb apiCall) async {
    try {
      final response = await apiCall.call();
      if (response.statusCode == HttpStatus.ok) return response;
      final errors = jsonDecode(response.body)['errors'] as List<dynamic>;
      throw ApiException(errors.map((e) => e.toString()));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException([e.toString()]);
    }
  }
}
