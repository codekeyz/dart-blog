import 'dart:async';

import 'package:yaroo/http/http.dart';
import 'package:yaroo/yaroo.dart';

import '../../src/controllers/auth_controller.dart';
import '../routes/api.dart' as api;
import '../routes/web.dart' as web;

class RouteServiceProvider extends ServiceProvider {
  @override
  FutureOr<void> boot() {
    app.useRoutes(
      () => [
        Route.group('api').routes([
          Route.post('/auth/login', (AuthController, #login)),
          Route.post('/auth/register', (AuthController, #register)),
        ]),

        /*|--------------------------------------------------------------------------
          | API Routes
          |--------------------------------------------------------------------------*/
        Route.middleware('auth:api').group('api').routes(api.routes),

        /*|--------------------------------------------------------------------------
          | Web Routes
          |--------------------------------------------------------------------------*/
        Route.middleware('web').group('/').routes(web.routes),
      ],
    );
  }
}
