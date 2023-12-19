import 'package:yaroo/http/http.dart';
import 'package:yaroo/http/kernel.dart' as prefix01;

class Kernel extends prefix01.Kernel {
  @override
  List<Middleware> get $middleware => [];

  @override
  Map<String, List<Middleware>> get $middlewareAliases => {};

  @override
  Map<String, List<Middleware>> get $middlewareGroups => {};
}
