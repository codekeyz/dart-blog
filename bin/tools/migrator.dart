// ignore: depend_on_referenced_packages
import 'package:yaroo_cli/orm/runner.dart';

import '../../database/config.dart' as orm;
import 'migrator.reflectable.dart';

export 'package:backend/src/models/models.dart';

void main(List<String> args) async {
  initializeReflectable();
  await OrmCLIRunner.start(args, orm.config);
}
