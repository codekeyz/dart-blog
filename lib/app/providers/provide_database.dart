import 'package:yaroo/http/http.dart';
import 'package:yaroorm/yaroorm.dart';

class DatabaseServiceProvider extends ServiceProvider {
  @override
  void boot() async {
    await DB.defaultDriver.connect();
  }
}
