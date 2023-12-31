import 'package:yaroo/yaroo.dart';

import 'http/kernel.dart';

export 'package:zomato/src/controllers/controllers.dart';
export 'package:zomato/src/models/models.dart';
export 'package:zomato/src/models/dto/dto.dart';
export 'providers/providers.dart';

class App extends ApplicationFactory {
  App(AppConfig appConfig) : super(Kernel(), appConfig);
}
