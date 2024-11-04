import 'dart:io';

import 'package:bcrypt/bcrypt.dart';
import 'package:pharaoh/pharaoh.dart';
import 'package:pharaoh/pharaoh_next.dart';
import 'package:shared/models.dart';

import '../dto/dto.dart';
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
    final userExists = await UserQuery.where((user) => user.email(data.email)).exists();
    if (userExists) {
      return response.json(
        _makeError(['Email already taken']),
        statusCode: HttpStatus.badRequest,
      );
    }

    final hashedPass = BCrypt.hashpw(data.password, BCrypt.gensalt());
    final newUser = await UserQuery.insert(NewUser(
      name: data.name,
      email: data.email,
      password: hashedPass,
    ));

    return response.json(_userResponse(newUser));
  }

  Response get invalidLogin => response.unauthorized(data: _makeError(['Email or Password not valid']));

  Map<String, dynamic> _userResponse(User user) => {'user': user.toJson()};

  Map<String, dynamic> _makeError(List<String> errors) => {'errors': errors};
}
