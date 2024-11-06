import 'dart:io';

import 'package:backend/src/services/services.dart';
import 'package:logging/logging.dart';
import 'package:pharaoh/pharaoh.dart';
import 'package:pharaoh/pharaoh_next.dart';

class CoreProvider extends ServiceProvider {
  @override
  void register() {
    final cookieConfig = CookieOpts(
      signed: true,
      secret: config.key,
      secure: !config.isDebug,
      maxAge: const Duration(hours: 1),
    );

    app.singleton<CookieOpts>(cookieConfig);

    app.singleton<AuthService>(AuthService(config.key, config.url));

    Logger.root
      ..level = Level.ALL
      ..onRecord.listen((record) {
        stdout.writeln('${record.level.name}: ${record.time}: ${record.message}');
      });

    app.singleton<Logger>(Logger(config.environment));
  }
}
