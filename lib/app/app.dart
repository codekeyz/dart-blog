import 'package:yaroo/yaroo.dart';

import 'http/kernel.dart';

export 'package:zomato/src/controllers/controllers.dart';

export 'providers/providers.dart';

class App extends ApplicationFactory {
  App(ConfigResolver appConfig, {super.dbConfig}) : super(Kernel(), appConfig);
}
