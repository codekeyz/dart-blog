import 'dart:io';

import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:yaroo/http/http.dart';

class CorsMiddleware extends Middleware {
  late HandlerFunc _corsMdw;

  CorsMiddleware() {
    _corsMdw = useShelfMiddleware(corsHeaders(
      headers: {
        HttpHeaders.accessControlAllowOriginHeader: 'http://localhost:60154/',
      },
    ));
  }

  @override
  HandlerFunc? get handler => _corsMdw;
}
