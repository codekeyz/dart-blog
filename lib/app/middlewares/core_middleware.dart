import 'package:logger/logger.dart';
import 'package:yaroo/http/http.dart';

class CoreMiddleware extends Middleware {
  late HandlerFunc _webMdw;
  final Logger _logger;

  CoreMiddleware(this._logger) {
    // setup cookie parser
    final cookieConfig = app.instanceOf<CookieOpts>();
    final cookieParserMdw = cookieParser(opts: cookieConfig);

    /// setup logger
    loggerMdw(Request req, Response res, NextFunction next) {
      _logger.i('Req: ${req.method.name}:${req.path}');
      next();
    }

    if (app.config.environment == 'development') {
      _webMdw = loggerMdw.chain(cookieParserMdw);
    } else {
      _webMdw = cookieParserMdw;
    }
  }

  @override
  HandlerFunc get handler => _webMdw;
}
