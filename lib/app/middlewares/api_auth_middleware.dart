import 'package:yaroo/http/http.dart';

import '../../src/models/user/user.dart';
import '../../src/services/auth_service.dart';

class ApiAuthMiddleware extends Middleware {
  final AuthService _authService;

  ApiAuthMiddleware(this._authService);

  @override
  handle(Request req, Response res, NextFunction next) async {
    final userId = _authService.validateRequest(req);
    if (userId == null) return next(res.unauthorized());

    final user = await UserQuery.findById(userId);
    if (user == null) return next(res.unauthorized());

    return next(req..auth = user);
  }
}
