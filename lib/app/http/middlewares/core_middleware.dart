import 'dart:io';

import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:yaroo/http/http.dart';

class CoreMiddleware extends Middleware {
  late HandlerFunc _webMdw;
  final CookieOpts _cookieConfig;

  CoreMiddleware(this._cookieConfig) {
    // setup cookie parser
    final cookieParserMdw = cookieParser(opts: _cookieConfig);

    // setup cors
    final corsMiddleware = useShelfMiddleware(corsHeaders(
      headers: {
        HttpHeaders.accessControlAllowOriginHeader: 'http://localhost:55366',
        HttpHeaders.accessControlAllowCredentialsHeader: 'true',
      },
    ));

    _webMdw = cookieParserMdw.chain(corsMiddleware);
  }

  @override
  HandlerFunc? get handler => _webMdw;
}
