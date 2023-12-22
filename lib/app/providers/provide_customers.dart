import 'dart:async';

import 'package:yaroo/http/http.dart';
import 'package:zomato/src/services/services.dart';

class CustomerServiceProvider extends ServiceProvider {
  CustomerServiceProvider();

  @override
  FutureOr<void> boot() {
    app
      ..singleton<UserService>(UserService())
      ..singleton<ServiceB>(ServiceB());
  }
}
