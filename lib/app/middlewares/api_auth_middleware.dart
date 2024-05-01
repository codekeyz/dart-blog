import 'package:backend/src/models/user/user.dart';
import 'package:backend/src/services/services.dart';
import 'package:pharaoh/next/http.dart';

class ApiAuthMiddleware extends ClassMiddleware {
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
