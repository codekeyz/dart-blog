import 'package:path/path.dart' as path;
import 'package:pharaoh/next/core.dart';
import 'package:yaroorm/yaroorm.dart';

@DB.useConfig
final config = YaroormConfig(
  // isDebugMode ?
  'test_db'
  //  : 'mysql'
  ,
  connections: [
    DatabaseConnection('test_db', DatabaseDriverType.sqlite, database: path.absolute('database', 'db.sqlite')),
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
);
