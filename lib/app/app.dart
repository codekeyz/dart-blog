import 'package:yaroo/yaroo.dart';

export 'providers/providers.dart';
import 'http/kernel.dart';

export '../src/controllers/controllers.dart';
export '../src/models/models.dart';
export '../src/models/dto/dto.dart';

class App extends ApplicationFactory {
  App(AppConfig appConfig) : super(Kernel(), appConfig);
}
