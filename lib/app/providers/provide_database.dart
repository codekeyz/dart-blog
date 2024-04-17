import 'package:pharaoh/next/http.dart';
import 'package:yaroorm/yaroorm.dart';

class DatabaseServiceProvider extends ServiceProvider {
  @override
  void boot() async => DB.defaultDriver.connect();
}
