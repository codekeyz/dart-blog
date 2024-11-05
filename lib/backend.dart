import 'dart:async';
import 'dart:io';

import 'package:backend/src/utils/config.dart';
import 'package:logging/logging.dart';
import 'package:pharaoh/pharaoh_next.dart';

import 'app/middlewares/core_middleware.dart';
import 'app/middlewares/api_auth_middleware.dart';
import 'app/providers/providers.dart';

export 'src/controllers/controllers.dart';
export 'src/dto/dto.dart';

final blogApp = App(appConfig);

class App extends ApplicationFactory with AppInstance {
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

    app.instanceOf<Logger>().severe(exception, null, error.trace);

    return super.onApplicationException(error, request, response);
  }
}
