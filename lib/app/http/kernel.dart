import 'dart:async';
import 'dart:io';

import 'package:yaroo/http/http.dart';
import 'package:yaroo/http/kernel.dart' as prefix01;
import 'package:yaroo/http/meta.dart';

import 'middlewares/serve_static_middleware.dart';
import 'middlewares/api_auth_middleware.dart';
import 'middlewares/core_middleware.dart';
import 'middlewares/logger_middleware.dart';

class Kernel extends prefix01.Kernel {
  @override
  List<Type> get middleware => [CoreMiddleware, LoggerMiddleware];

  @override
  Map<String, List<Type>> get middlewareGroups => {
        'web': [ServeStaticMiddleware],
        'auth:api': [ApiAuthMiddleware],
      };

  @override
  FutureOr<Response> onApplicationException(Object error, Request request, Response response) {
    if (error is RequestValidationError) {
      return response.json(error.errorBody, statusCode: HttpStatus.badRequest);
    }

    return super.onApplicationException(error, request, response);
  }
}
