import 'dart:async';

import 'package:yaroo/http/http.dart';
import 'package:yaroo/yaroo.dart';
//
import 'package:zomato/app/routes/api.dart' as api;
import 'package:zomato/app/routes/web.dart' as web;

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
