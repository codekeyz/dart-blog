import 'package:yaroorm/yaroorm.dart';
import 'package:backend/backend.dart';

import '../database/config.dart' as orm;
import 'backend.reflectable.dart';

void main(List<String> arguments) async {
  initializeReflectable();

  DB.init(orm.config);

  await blogApp.bootstrap();
}
