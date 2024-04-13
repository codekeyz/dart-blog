import 'dart:io';

import 'package:yaroo/http/http.dart';
import 'package:yaroo/http/meta.dart';

import 'package:bcrypt/bcrypt.dart';

import '../dto/dto.dart';
import '../models/user/user.dart';
import '../services/services.dart';

class AuthController extends HTTPController {
  final AuthService _authService;

  AuthController(this._authService);

  Future<Response> login(@body LoginUserDTO data) async {
    final user = await UserQuery.findByEmail(data.email);
    if (user == null) return invalidLogin;

    final match = BCrypt.checkpw(data.password, user.password);
    if (!match) return invalidLogin;

    final token = _authService.getAccessTokenForUser(user);
    final cookie = bakeCookie('auth', token, app.instanceOf<CookieOpts>());

    return response.withCookie(cookie).json(_userResponse(user));
  }

  Future<Response> register(@body CreateUserDTO data) async {
    final existing = await UserQuery.findByEmail(data.email);
    if (existing != null) {
      return response.json(_makeError(['Email already taken']), statusCode: HttpStatus.badRequest);
    }

    final hashedPass = BCrypt.hashpw(data.password, BCrypt.gensalt());
    final newUser = await UserQuery.create(name: data.name, email: data.email, password: hashedPass);

    return response.json(_userResponse(newUser));
  }

  Response get invalidLogin => response.unauthorized(data: _makeError(['Email or Password not valid']));

  Map<String, dynamic> _userResponse(User user) => {'user': user.toJson()};

  Map<String, dynamic> _makeError(List<String> errors) => {'errors': errors};
}
