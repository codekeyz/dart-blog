import 'package:backend/src/models/models.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class AuthService {
  final String jwtKey;
  final String issuer;

  const AuthService(this.jwtKey, this.issuer);

  String getAccessTokenForUser(User user) {
    final secretKey = SecretKey(jwtKey);
    final jwt = JWT(user.toPublic, issuer: issuer, subject: user.id!.toString(), jwtId: 'access-token');
    return jwt.sign(secretKey, algorithm: JWTAlgorithm.HS256, expiresIn: Duration(minutes: 10));
  }
}
