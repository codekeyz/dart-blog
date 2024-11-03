import 'package:path/path.dart' as path;
import 'package:pharaoh/pharaoh_next.dart';
import 'package:yaroorm/yaroorm.dart';

enum AppEnvironment {
  local(),
  staging(),
  prod();

  const AppEnvironment();

  DatabaseConnection get dbCon => switch (this) {
        AppEnvironment.prod => DatabaseConnection(
            'prod',
            DatabaseDriverType.pgsql,
            port: env<int>('DB_PORT', 6543),
            host: env<String>('DB_HOST', ''),
            username: env<String>('DB_USERNAME', ''),
            password: env<String>('DB_PASSWORD', ''),
            database: env<String>('DB_DATABASE', ''),
            secure: true,
          ),
        _ => DatabaseConnection('local', DatabaseDriverType.sqlite, database: path.absolute('database', 'db.sqlite')),
      };
}

// Database password: dYEQHjitxY53TMyH
// Database username: postgres.srzosrzaqllpicsemkup
// Database host: aws-0-us-east-1.pooler.supabase.com
// Database name: postgres

@DB.useConfig
final config = YaroormConfig(
  AppEnvironment.local.name,
  connections: AppEnvironment.values.map((e) => e.dbCon).toList(),
);
