import 'package:path/path.dart' as path;
import 'package:yaroo/yaroo.dart';
import 'package:yaroorm/yaroorm.dart';

import './migrations/create_articles_table.dart';
import './migrations/create_users_table.dart';

final config = YaroormConfig(
  env<String>('DB_CONNECTION', 'test_db'),
  connections: [
    DatabaseConnection(
      'test_db',
      DatabaseDriverType.sqlite,
      database: env('DB_DATABASE', path.absolute('database', 'db.sqlite')),
    ),
    DatabaseConnection(
      'mysql',
      DatabaseDriverType.mysql,
      port: env<int>('DB_PORT', 0),
      host: env<String>('DB_HOST', ''),
      username: env<String>('DB_USERNAME', ''),
      password: env<String>('DB_PASSWORD', ''),
      database: env<String>('DB_DATABASE', ''),
      secure: true,
    ),
  ],
  migrations: [CreateUsersTable(), CreateArticlesTable()],
);