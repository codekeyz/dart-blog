import 'package:yaroo/http/http.dart';

class CoreConfigProvider extends ServiceProvider {
  late CookieOpts _cookieOpts;

  CoreConfigProvider() {
    _cookieOpts = CookieOpts(signed: true, secret: app.config.key, maxAge: const Duration(minutes: 10));
  }

  @override
  void register() {
    app.singleton<CookieOpts>(_cookieOpts);
  }
}
