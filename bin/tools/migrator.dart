import 'package:yaroo/db/migration/migrator.dart';

import '../../config/database.dart' as db;

void main(List<String> args) async {
  if (args.isEmpty) return;

  Migrator.processCmd(args[0], db.config, cmdArguments: args.sublist(1));
}
