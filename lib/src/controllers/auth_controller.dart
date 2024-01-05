import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:yaroo/http/http.dart';
import 'package:yaroo/http/meta.dart';
import 'package:yaroorm/yaroorm.dart';
import 'package:backend/src/models/dto/dto.dart';
import 'package:backend/src/models/models.dart';
import 'package:backend/src/services/services.dart';
import 'package:bcrypt/bcrypt.dart';

class AuthController extends HTTPController {
  final UserService userSvc;

  AuthController(this.userSvc);

  Future<Response> login(@body LoginUserDTO data) async {
    final user = await DB.query<User>().whereEqual('email', data.email).findOne();
    if (user == null) return invalidLogin;

    final match = BCrypt.checkpw(data.password, user.password);
    if (!match) return invalidLogin;

    final token = _getAccessTokenForUser(user);
    final cookie = bakeCookie('auth', token, app.instanceOf<CookieOpts>());

    return response.withCookie(cookie).json(_userResponse(user));
  }

  Future<Response> register(@body CreateUserDTO data) async {
    final existing = await DB.query<User>().whereEqual('email', data.email).findOne();
    if (existing != null) {
      return response.json(_makeError(['Email already taken']), statusCode: HttpStatus.badRequest);
    }

    final hashedPass = BCrypt.hashpw(data.password, BCrypt.gensalt());
    final newUser = await userSvc.newUser(data.name, data.email, hashedPass);

    return response.json(_userResponse(newUser));
  }

  Map<String, dynamic> _userResponse(User user) => {'user': user.toPublic};

  Response get invalidLogin => response.unauthorized(data: _makeError(['Email or Password not valid']));

  Map<String, dynamic> _makeError(List<String> errors) => {'errors': errors};

  String _getAccessTokenForUser(User user) {
    final secretKey = SecretKey(app.config.key);
    final jwt = JWT(user.toPublic, issuer: app.config.url, subject: user.id!.toString(), jwtId: 'access-token');
    return jwt.sign(secretKey, algorithm: JWTAlgorithm.HS256, expiresIn: Duration(minutes: 10));
  }
}
