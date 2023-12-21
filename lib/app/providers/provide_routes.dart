import 'dart:async';

import 'package:yaroo/http/http.dart';
import 'package:yaroo/yaroo.dart';

import '../routes/api.dart' as api;
import '../routes/web.dart' as web;

class RouteServiceProvider extends ServiceProvider {
  @override
  FutureOr<void> boot() {
    app.useRoutes(
      () => [
        /*
    |--------------------------------------------------------------------------
    | API Routes
    |--------------------------------------------------------------------------
    */
        Route.group('api', middlewares: []).routes(api.routes),

        /*
    |--------------------------------------------------------------------------
    | Web Routes
    |--------------------------------------------------------------------------
    */

        Route.group('/', middlewares: []).routes(web.routes),
      ],
    );
  }
}
