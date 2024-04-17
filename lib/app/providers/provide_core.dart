import 'package:backend/src/services/services.dart';
import 'package:logger/logger.dart';
import 'package:pharaoh/next/http.dart';

class CoreProvider extends ServiceProvider {
  @override
  void register() {
    final cookieConfig = CookieOpts(signed: true, secret: app.config.key, maxAge: const Duration(hours: 1));

    app.singleton<CookieOpts>(cookieConfig);

    app.singleton<AuthService>(AuthService(app.config.key, app.config.url));

    app.singleton<Logger>(Logger(printer: PrettyPrinter(), filter: _CustomLogFilter(app.config.isDebug)));
  }
}

class _CustomLogFilter extends LogFilter {
  final bool loggingEnabled;

  _CustomLogFilter(this.loggingEnabled);

  @override
  bool shouldLog(LogEvent event) => loggingEnabled;
}
