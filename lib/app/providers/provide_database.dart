import 'package:logging/logging.dart';
import 'package:pharaoh/pharaoh_next.dart';
import 'package:yaroorm/yaroorm.dart';

class DatabaseServiceProvider extends ServiceProvider {
  @override
  void boot() async {
    await DB.defaultDriver.connect();

    final logger = app.instanceOf<Logger>();
    logger.info('Using ${DB.defaultConnection.info.name} database');
  }
}
