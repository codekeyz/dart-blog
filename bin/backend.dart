import 'package:backend/backend.dart';

import 'backend.reflectable.dart';

import '../database/database.dart' as db;

void main(List<String> arguments) async {
  initializeReflectable();
  db.initializeORM();

  await blogApp.bootstrap();
}
