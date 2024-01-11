import 'package:logger/logger.dart';
import 'package:yaroo/http/http.dart';

class LoggerMiddleware extends Middleware {
  final Logger _logger;

  LoggerMiddleware(this._logger);

  @override
  handle(Request req, Response res, NextFunction next) {
    _logger.i('Req: ${req.method.name}:${req.path}');
    next();
  }
}
