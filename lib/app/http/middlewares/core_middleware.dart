import 'dart:io';

import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:yaroo/http/http.dart';

class CoreMiddleware extends Middleware {
  late HandlerFunc _webMdw;

  CoreMiddleware() {
    // setup cookie parser
    final cookieConfig = app.instanceOf<CookieOpts>();
    final cookieParserMdw = cookieParser(opts: cookieConfig);

    // setup cors
    final corsMiddleware = useShelfMiddleware(corsHeaders(
      headers: {
        HttpHeaders.accessControlAllowOriginHeader: 'http://localhost:57448',
        HttpHeaders.accessControlAllowCredentialsHeader: 'true',
      },
    ));

    _webMdw = cookieParserMdw.chain(corsMiddleware);
  }

  @override
  HandlerFunc? get handler => _webMdw;
}
