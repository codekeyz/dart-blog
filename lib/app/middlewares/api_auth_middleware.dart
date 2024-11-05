import 'package:backend/src/models.dart';
import 'package:pharaoh/pharaoh_next.dart';

import '../../src/services/auth_service.dart';

class ApiAuthMiddleware extends ClassMiddleware {
  final AuthService _authService;

  ApiAuthMiddleware(this._authService);

  @override
  handle(Request req, Response res, NextFunction next) async {
    final userId = _authService.validateRequest(req);
    if (userId == null) return next(res.unauthorized());

    final user = await ServerUserQuery.findById(userId);
    if (user == null) return next(res.unauthorized());

    return next(req..auth = user);
  }
}
