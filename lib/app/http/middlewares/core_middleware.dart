import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_helmet/shelf_helmet.dart';
import 'package:yaroo/http/http.dart';

class CoreMiddleware extends Middleware {
  late HandlerFunc _webMdw;

  CoreMiddleware() {
    // setup cookie parser
    final cookieConfig = app.instanceOf<CookieOpts>();
    final cookieParserMdw = cookieParser(opts: cookieConfig);

    // setup helmet
    final shelfHelmet = useShelfMiddleware(helmet());

    // setup cors
    final corsMiddleware = useShelfMiddleware(corsHeaders(
      headers: {ACCESS_CONTROL_ALLOW_ORIGIN: 'http://localhost:58690/', ACCESS_CONTROL_ALLOW_CREDENTIALS: 'true'},
    ));

    _webMdw = shelfHelmet.chain(corsMiddleware).chain(cookieParserMdw);
  }

  @override
  HandlerFunc get handler => _webMdw;
}
