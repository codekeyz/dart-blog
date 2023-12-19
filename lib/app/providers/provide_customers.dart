import 'dart:async';

import 'package:yaroo/http/http.dart';

import '../../src/services/service_a.dart';
import '../../src/services/service_b.dart';

class CustomerServiceProvider extends ServiceProvider {
  CustomerServiceProvider();

  @override
  FutureOr<void> boot() {
    app
      ..singleton<UserService>(UserService())
      ..singleton<ServiceB>(ServiceB());
  }
}
