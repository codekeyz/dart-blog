import 'package:yaroorm/yaroorm.dart';
import 'package:backend/app/app.dart';

import '../config/app.dart' as app;
import '../config/database.dart' as db;
import 'backend.reflectable.dart';

final zomatoApp = App(app.config);

void main(List<String> arguments) async {
  initializeReflectable();

  DB.init(db.config);

  await zomatoApp.bootstrap();
}
