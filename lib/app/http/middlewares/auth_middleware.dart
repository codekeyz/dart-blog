import 'package:yaroo/http/http.dart';

class AuthMiddleware extends Middleware {
  @override
  handle(Request req, Response res, NextFunction next) {
    next();
  }
}
