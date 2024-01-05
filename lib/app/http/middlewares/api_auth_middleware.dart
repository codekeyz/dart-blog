import 'package:yaroo/http/http.dart';

class ApiAuthMiddleware extends Middleware {
  @override
  handle(Request req, Response res, NextFunction next) {
    next();
  }
}
