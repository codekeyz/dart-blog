import 'dart:async';
import 'dart:io';

import 'package:backend/src/services/services.dart';
import 'package:yaroo/http/http.dart';
import 'package:yaroo/http/meta.dart';

class CoreProvider extends ServiceProvider {
  @override
  void register() {
    final cookieConfig = CookieOpts(signed: true, secret: app.config.key, maxAge: const Duration(hours: 1));

    app.singleton<CookieOpts>(cookieConfig);

    app.singleton<AuthService>(AuthService(app.config.key, app.config.url));

    app.useErrorHandler(_applicationErrorHandler);
  }

  FutureOr<Response> _applicationErrorHandler(Object error, ReqRes reqRes) async {
    final response = reqRes.res;
    if (error is RequestValidationError) {
      return response.json(error.errorBody, statusCode: HttpStatus.badRequest);
    }

    return response.internalServerError(error.toString());
  }
}
