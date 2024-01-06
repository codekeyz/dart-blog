import 'package:backend/src/services/services.dart';
import 'package:yaroo/http/http.dart';

class CoreProvider extends ServiceProvider {
  @override
  void register() {
    final cookieConfig = CookieOpts(signed: true, secret: app.config.key, maxAge: const Duration(hours: 1));

    app.singleton<CookieOpts>(cookieConfig);

    app.singleton<AuthService>(AuthService(app.config.key, app.config.url));
  }
}
