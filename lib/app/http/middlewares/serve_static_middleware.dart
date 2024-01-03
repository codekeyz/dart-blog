import 'dart:io';

import 'package:yaroo/http/http.dart';
import 'package:path/path.dart' as path;

class ServeStaticMiddleware extends Middleware {
  static const supportedExtensions = [
    'js',
    'ico',
    'json',
    'html',
    'png',
    'otf',
    'ttf'
  ];

  @override
  handle(Request req, Response res, NextFunction next) async {
    final requestPath = req.path;
    final lastPart = requestPath.split('.').last;

    if (!supportedExtensions.contains(lastPart) ||
        ![HTTPMethod.GET, HTTPMethod.GET].contains(req.method)) {
      return next();
    }

    final assetPath = path.join(Directory.current.path, 'public$requestPath');
    final requestedFile = File(assetPath);
    if (!await requestedFile.exists())
      return next(res.status(HttpStatus.notFound));

    next(res.send(requestedFile.openRead()));
  }
}
