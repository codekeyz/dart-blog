import 'package:yaroorm/yaroorm.dart';
import 'package:zomato/app/app.dart';

import '../config/app.dart' as app;
import '../config/database.dart' as db;
import 'zomato.reflectable.dart';

final zomatoApp = App(app.config);

void main(List<String> arguments) async {
  initializeReflectable();

  DB.init(db.config);

  await zomatoApp.bootstrap();
}
