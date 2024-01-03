import 'package:test/test.dart';
import 'package:yaroorm/yaroorm.dart';
import 'package:backend/app/app.dart';

import '../config/app.dart' as app;
import '../config/database.dart' as db;

import 'zomato_test.reflectable.dart';

final backend = App(app.config);

void main() {
  initializeReflectable();

  DB.init(db.config);

  setUpAll(() => backend.bootstrap(listen: false));

  group('Zomato API Tests', () {});
}
