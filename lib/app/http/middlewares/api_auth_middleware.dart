import 'package:pharaoh_jwt_auth/pharaoh_jwt_auth.dart';
import 'package:yaroo/http/http.dart';

class ApiAuthMiddleware extends Middleware {
  late HandlerFunc _useJwtMdw;

  ApiAuthMiddleware() {
    _useJwtMdw = jwtAuth(secret: () => SecretKey(app.config.key));
  }

  @override
  HandlerFunc? get handler => _useJwtMdw;
}
