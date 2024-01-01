import 'package:yaroo/http/http.dart';
import 'package:zomato/src/services/services.dart';

class UserServiceProvider extends ServiceProvider {
  @override
  void register() {
    app.singleton<UserService>(UserService());
  }
}