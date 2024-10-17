import 'package:path/path.dart' as path;
import 'package:yaroorm/yaroorm.dart';

@DB.useConfig
final config = YaroormConfig(
  'test_db',
  connections: [
    DatabaseConnection('test_db', DatabaseDriverType.sqlite, database: path.absolute('database', 'db.sqlite')),
  ],
);
