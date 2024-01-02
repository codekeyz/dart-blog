import 'dart:io';

import 'package:yaroo/http/http.dart';
import 'package:path/path.dart' as path;

class ServeStaticMiddleware extends Middleware {
  @override
  handle(Request req, Response res, NextFunction next) async {
    final requestPath = req.path;
    if (!requestPath.startsWith('/assets/') || ![HTTPMethod.GET, HTTPMethod.GET].contains(req.method)) return next();
    final assetPath = path.join(Directory.current.path, 'public$requestPath');

    final requestedFile = File(assetPath);
    if (!await requestedFile.exists()) return next(res.status(HttpStatus.notFound));

    next(res.send(requestedFile.openRead()));
  }
}
