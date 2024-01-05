import 'package:backend/src/services/services.dart';
import 'package:yaroo/http/http.dart';

class CoreProvider extends ServiceProvider {
  late CookieOpts _cookieOpts;

  CoreProvider() {
    _cookieOpts = CookieOpts(signed: true, secret: app.config.key, maxAge: const Duration(minutes: 10));
  }

  @override
  void register() {
    app.singleton<CookieOpts>(_cookieOpts);

    app.singleton<AuthService>(AuthService(app.config.key, app.config.url));
  }
}
