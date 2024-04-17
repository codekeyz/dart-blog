import 'dart:async';
import 'dart:io';

import 'package:pharaoh/next/core.dart';
import 'package:pharaoh/next/http.dart';
import 'package:pharaoh/next/router.dart';
import 'package:uuid/v4.dart';

import 'app/middlewares/core_middleware.dart';
import 'app/middlewares/api_auth_middleware.dart';
import 'app/providers/providers.dart';
import 'src/utils/utils.dart';

export 'src/controllers/controllers.dart';
export 'src/dto/dto.dart';

final blogApp = App(AppConfig(
  name: 'Dart Blog',
  environment: env<String>('APP_ENV', isDebugMode ? 'test' : 'development'),
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
  FutureOr<Response> onApplicationException(PharaohError error, Request request, Response response) {
    final exception = error.exception;
    if (exception is RequestValidationError) {
      return response.json(exception.errorBody, statusCode: HttpStatus.badRequest);
    }

    return super.onApplicationException(error, request, response);
  }
}
