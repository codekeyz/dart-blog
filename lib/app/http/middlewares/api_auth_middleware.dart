import 'package:backend/src/models/models.dart';
import 'package:backend/src/services/services.dart';
import 'package:yaroo/http/http.dart';
import 'package:yaroorm/yaroorm.dart';

class ApiAuthMiddleware extends Middleware {
  final AuthService _authService;

  ApiAuthMiddleware(this._authService);

  @override
  handle(Request req, Response res, NextFunction next) async {
    final userId = _authService.validateRequest(req);
    if (userId == null) return next(res.unauthorized());

    final user = await DB.query<User>().get(userId);
    if (user == null) return next(res.unauthorized());

    return next(req..auth = user);
  }
}
