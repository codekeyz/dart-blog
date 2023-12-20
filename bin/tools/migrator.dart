import 'package:yaroo/db/migration/cli.dart';

import '../../config/database.dart' as db;

void main(List<String> args) async {
  if (args.isEmpty) return;

  MigratorCLI.processCmd(args[0], db.config, cmdArguments: args.sublist(1));
}
