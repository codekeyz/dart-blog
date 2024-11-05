import 'package:path/path.dart' as path;
import 'package:pharaoh/pharaoh_next.dart';
import 'package:shared/shared.dart';
import 'package:uuid/v4.dart';
import 'package:yaroorm/yaroorm.dart';

final appConfig = AppConfig(
  name: 'Dart Blog',
  environment: env<String>('APP_ENV', appEnv.name),
  isDebug: appEnv == AppEnvironment.local,
  url: env<String>('APP_URL', 'http://localhost'),
  port: env<int>('PORT', 80),
  key: env('APP_KEY', UuidV4().generate()),
);

extension on AppEnvironment {
  DatabaseConnection get dbCon => switch (this) {
        AppEnvironment.prod => DatabaseConnection(
            AppEnvironment.prod.name,
            DatabaseDriverType.pgsql,
            port: env<int>('DB_PORT', 6543),
            host: env<String>('DB_HOST', ''),
            username: env<String>('DB_USERNAME', ''),
            password: env<String>('DB_PASSWORD', ''),
            database: env<String>('DB_DATABASE', ''),
            secure: true,
          ),
        _ => DatabaseConnection(
            AppEnvironment.local.name,
            DatabaseDriverType.sqlite,
            database: path.absolute('database', 'db.sqlite'),
          ),
      };
}

@DB.useConfig
final config = YaroormConfig(
  appEnv.name,
  connections: AppEnvironment.values.map((e) => e.dbCon).toList(),
);
