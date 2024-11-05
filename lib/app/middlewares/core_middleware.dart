import 'package:logging/logging.dart';
import 'package:pharaoh/pharaoh.dart';
import 'package:pharaoh/pharaoh_next.dart';

class CoreMiddleware extends ClassMiddleware {
  late Middleware _webMdw;
  final Logger _logger;

  CoreMiddleware(this._logger) {
    // setup cookie parser
    final cookieConfig = app.instanceOf<CookieOpts>();
    final cookieParserMdw = cookieParser(opts: cookieConfig);

    corsMiddleware(Request req, Response res, NextFunction next) {
      res = res
        ..header('Access-Control-Allow-Origin', 'http://localhost:57224')
        ..header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE')
        ..header('Access-Control-Allow-Headers', 'Content-Type, Authorization')
        ..header('Access-Control-Allow-Credentials', 'true')
        ..header('Access-Control-Max-Age', '3600');

      if (req.method == HTTPMethod.OPTIONS) {
        return next(res.status(200).end());
      }

      return next(res);
    }

    _webMdw = corsMiddleware.chain(cookieParserMdw).chain((req, res, next) {
      _logger.fine('${req.method.name}:${req.path}');
      next();
    });
  }

  @override
  Middleware get handler => _webMdw;
}
