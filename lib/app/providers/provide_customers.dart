import 'package:yaroo/http/http.dart';
import 'package:zomato/src/services/services.dart';

class CustomerServiceProvider extends ServiceProvider {
  CustomerServiceProvider();

  @override
  void register() {
    app
      ..singleton<UserService>(UserService())
      ..singleton<ServiceB>(ServiceB());
  }
}
