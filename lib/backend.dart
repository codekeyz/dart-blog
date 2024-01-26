import 'dart:async';
import 'dart:io';

import 'package:uuid/v4.dart';
import 'package:yaroo/http/http.dart';
import 'package:yaroo/http/meta.dart';
import 'package:yaroo/yaroo.dart';

import 'app/middlewares/core_middleware.dart';
import 'app/middlewares/api_auth_middleware.dart';
import 'app/providers/providers.dart';

export 'src/controllers/controllers.dart';
export 'src/models/models.dart';
export 'src/models/dto/dto.dart';

bool get isTestMode {
  var isDebug = false;
  assert(() {
    isDebug = true;
    return true;
  }());
  return isDebug;
}

final blogApp = App(AppConfig(
  name: 'Dart Blog',
  environment: env<String>('APP_ENV', isTestMode ? 'test' : 'development'),
  isDebug: env<bool>('APP_DEBUG', true),
  url: env<String>('APP_URL', 'http://localhost'),
  port: env<int>('PORT', 80),
  key: env('APP_KEY', UuidV4().generate()),
));

class App extends ApplicationFactory {
  App(super.appConfig);

  @override
  List<Type> get middlewares => [CoreMiddleware];

  @override
  Map<String, List<Type>> get middlewareGroups => {
        'web': [],
        'api:auth': [ApiAuthMiddleware],
      };

  @override
  List<Type> get providers => ServiceProvider.defaultProviders
    ..addAll([
      CoreProvider,
      RouteServiceProvider,
      DatabaseServiceProvider,
      BlogServiceProvider,
    ]);

  @override
  FutureOr<Response> onApplicationException(Object error, Request request, Response response) {
    if (error is RequestValidationError) {
      return response.json(error.errorBody, statusCode: HttpStatus.badRequest);
    }

    return super.onApplicationException(error, request, response);
  }
}
