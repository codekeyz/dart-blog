import 'package:yaroo/orm/orm.dart';

import '../../config/database.dart' as db;
import '../zomato.dart';

void main(List<String> args) async {
  if (args.isEmpty) return;

  await zomatoApp.bootstrap(bootstap_pharaoh: false);

  final dbConfig = db.config.call();

  await processMigrationCmd(
    args[0],
    List<Migration>.from(dbConfig['migrations']),
    DB.defaultDriver,
    cmdArguments: args.sublist(1),
  );
}
