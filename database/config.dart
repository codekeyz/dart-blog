import 'package:path/path.dart' as path;
import 'package:yaroorm/yaroorm.dart';

// Database password: dYEQHjitxY53TMyH
// Database username: postgres.srzosrzaqllpicsemkup
// Database host: aws-0-us-east-1.pooler.supabase.com
// Database name: postgres

// DatabaseConnection(
//       'pg',
//       DatabaseDriverType.pgsql,
//       port: env<int>('DB_PORT', 6543),
//       host: env<String>('DB_HOST', ''),
//       username: env<String>('DB_USERNAME', ''),
//       password: env<String>('DB_PASSWORD', ''),
//       database: env<String>('DB_DATABASE', ''),
//       secure: true,
//     ),

@DB.useConfig
final config = YaroormConfig(
  'test_db',
  connections: [
    DatabaseConnection('test_db', DatabaseDriverType.sqlite, database: path.absolute('database', 'db.sqlite')),
  ],
);
