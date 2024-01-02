import 'package:yaroo/http/http.dart';

class SessionMiddleware extends Middleware {
  HandlerFunc get _useSession {
    final cookieOpts = CookieOpts(secret: app.config.key, signed: true);

    final cookieParserMdw = cookieParser(opts: cookieOpts);
    final session = sessionMdw(cookie: cookieOpts, saveUninitialized: false);

    return cookieParserMdw.chain(session);
  }

  @override
  handle(Request req, Response res, NextFunction next) => _useSession(req, res, next);
}
