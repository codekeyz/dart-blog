import 'dart:io';

import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:yaroo/http/http.dart';

/// This sets up cookie parsing and CORS middleware
class CoreMiddleware extends Middleware {
  late HandlerFunc _webMdw;

  CoreMiddleware() {
    // setup cookie parser
    final cookieParserMdw = cookieParser(opts: app.instanceOf<CookieOpts>());

    // setup cors
    final corsMiddleware = useShelfMiddleware(corsHeaders(
      headers: {HttpHeaders.accessControlAllowOriginHeader: 'http://localhost:60154/'},
    ));

    _webMdw = cookieParserMdw.chain(corsMiddleware);
  }

  @override
  HandlerFunc? get handler => _webMdw;
}
