import 'package:backend/src/services/services.dart';
import 'package:yaroo/http/http.dart';

class ApiAuthMiddleware extends Middleware {
  final AuthService _authService;
  final UserService _userService;

  ApiAuthMiddleware(this._userService, this._authService);

  @override
  handle(Request req, Response res, NextFunction next) async {
    final userId = _authService.validateRequest(req);
    if (userId == null) return next(res.unauthorized());

    final user = await _userService.getUser(userId);
    if (user == null) return next(res.unauthorized());

    return next(req..auth = user);
  }
}
