import 'dart:async';
import 'dart:io';

import 'package:yaroo/http/http.dart';

class FrontendProvider extends ServiceProvider {
  final viewEngine = FrontendViewEngine();

  @override
  void register() {
    app.useViewEngine(viewEngine);
  }
}

class FrontendViewEngine extends ViewEngine {
  final publicDir = '${Directory.current.path}/public';

  String get extension => 'html';

  @override
  String get name => 'Static File Renderer';

  @override
  FutureOr<String> render(String template, data) async {
    final file = File('$publicDir/$template.$extension');
    return file.readAsString();
  }
}
