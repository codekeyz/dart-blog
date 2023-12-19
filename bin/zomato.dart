import 'package:zomato/app/app.dart';

import '../config/app.dart' as a1;
import '../config/database.dart' as db;
import 'zomato.reflectable.dart';

final zomatoApp = App(a1.config, dbConfig: db.config);

void main(List<String> arguments) async {
  initializeReflectable();

  await zomatoApp.bootstrap();
}
