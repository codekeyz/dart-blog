import 'package:zomato/app/app.dart';

import '../config/app.dart' as app;
import '../config/database.dart' as db;
import 'zomato.reflectable.dart';

final zomatoApp = App(app.config, dbConfig: db.config);

void main(List<String> arguments) async {
  initializeReflectable();

  await zomatoApp.bootstrap();
}
