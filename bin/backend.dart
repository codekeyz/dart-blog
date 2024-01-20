import 'package:yaroorm/yaroorm.dart';
import 'package:backend/app/app.dart';

import '../config/app.dart' as app;
import '../config/database.dart' as db;
import 'backend.reflectable.dart';

final blogApp = App(app.config);

void main(List<String> arguments) async {
  initializeReflectable();

  await blogApp.bootstrap();
}
