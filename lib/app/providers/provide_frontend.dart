import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:yaroo/http/http.dart';

class FrontendProvider extends ServiceProvider {
  final viewEngine = FrontendViewEngine();

  @override
  void register() {
    app.useViewEngine(viewEngine);
  }
}

class FrontendViewEngine extends ViewEngine {
  final publicDir = path.join(Directory.current.path, 'public');

  String get extension => 'html';

  @override
  String get name => 'Static File Renderer';

  @override
  FutureOr<String> render(String template, data) async {
    final file = File('$publicDir/$template.$extension');
    return await file.readAsString();
  }
}
