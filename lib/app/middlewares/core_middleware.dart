import 'package:logger/logger.dart';
import 'package:pharaoh/pharaoh.dart';
import 'package:pharaoh/pharaoh_next.dart';

class CoreMiddleware extends ClassMiddleware {
  late Middleware _webMdw;
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
  Middleware get handler => _webMdw;
}
