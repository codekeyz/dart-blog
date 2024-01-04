import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'models/user.dart';

class ApiException extends HttpException {
  final List<String> errors;
  ApiException(this.errors) : super(errors.join('\n'));
}

class ApiService {
  Uri getUri(String path) => Uri(path: '/api$path');

  Future<User> loginUser(String email, String password) async {
    try {
      final result = await http.post(getUri('/auth/login'), body: {'email': email, 'password': password});
      handleErrorIfAny(result);

      final data = jsonDecode(result.body)['user'];
      return User.fromJson(data);
    } catch (e) {
      throw ApiException([e.toString()]);
    }
  }

  Future<bool> registerUser(String displayName, String email, String password) async {
    try {
      final result =
          await http.post(getUri('/auth/register'), body: {'name': displayName, 'email': email, 'password': password});
      handleErrorIfAny(result);
      return true;
    } catch (e) {
      throw ApiException([e.toString()]);
    }
  }

  void handleErrorIfAny(http.Response response) {
    if (response.statusCode == HttpStatus.ok) return;
    final errors = jsonDecode(response.body)['errors'] as Iterable<String>;
    throw ApiException(errors.toList());
  }
}
