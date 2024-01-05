import 'package:yaroorm/migration/cli.dart';
import 'package:yaroorm/yaroorm.dart';

import '../../config/database.dart' as db;

import 'migrator.reflectable.dart';

export 'package:backend/src/models/models.dart';

void main(List<String> args) async {
  if (args.isEmpty) return print('Nothing to do here');

  initializeReflectable();

  DB.init(db.config);

  await MigratorCLI.processCmd(args[0], cmdArguments: args.sublist(1));
}
