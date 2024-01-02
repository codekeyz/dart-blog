import 'dart:io';

import 'package:yaroo/http/http.dart';
import 'package:yaroo/http/meta.dart';
import 'package:yaroorm/yaroorm.dart';
import 'package:zomato/src/models/dto/dto.dart';
import 'package:zomato/src/models/models.dart';
import 'package:zomato/src/services/services.dart';
import 'package:bcrypt/bcrypt.dart';

class AuthController extends HTTPController {
  final UserService userSvc;

  AuthController(this.userSvc);

  Future<Response> login(@body LoginUserDTO data) async {
    final user = await DB.query<User>().whereEqual('email', data.email).findOne();
    if (user == null) return unauthorized;

    final compare = BCrypt.checkpw(data.password, user.password);
    if (!compare) return unauthorized;

    if (!expectsJson) return redirectTo('/dashboard');
    return jsonResponse(_userResponse(user));
  }

  Future<Response> register(@body CreateUserDTO data) async {
    final existing = await DB.query<User>().whereEqual('email', data.email).findOne();
    if (existing != null) return badRequest('Email already taken');

    final hashedPass = BCrypt.hashpw(data.password, BCrypt.gensalt());
    await userSvc.newUser(data.name, data.email, hashedPass);

    if (!expectsJson) return redirectTo('/login');
    return response.status(HttpStatus.ok);
  }

  Response get unauthorized => response.status(HttpStatus.unauthorized).end();

  Map<String, dynamic> _userResponse(User user) => {'user': user.toJson()..remove('password')};
}
