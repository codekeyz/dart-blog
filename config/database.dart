import 'package:path/path.dart' as path;
import 'package:yaroo/yaroo.dart';
import 'package:yaroorm/config.dart';
import 'package:yaroorm/yaroorm.dart';

import '../database/migrations/create_articles_table.dart';
import '../database/migrations/create_users_table.dart';

final config = YaroormConfig(
  env<String>('DB_CONNECTION', defaultValue: 'sqlite'),
  connections: [
    DatabaseConnection(
      'sqlite',
      DatabaseDriverType.sqlite,
      database: env(
        'DB_DATABASE',
        defaultValue: path.absolute('database', 'db.sqlite'),
      ),
    ),
    DatabaseConnection(
      'mysql',
      DatabaseDriverType.mysql,
      port: env<int>('DB_PORT', defaultValue: 0),
      host: env<String>('DB_HOST', defaultValue: ''),
      username: env<String>('DB_USERNAME', defaultValue: ''),
      password: env<String>('DB_PASSWORD', defaultValue: ''),
      database: env<String>('DB_DATABASE', defaultValue: ''),
      secure: true,
    ),
  ],
  migrations: [CreateUsersTable(), CreateArticlesTable()],
);
