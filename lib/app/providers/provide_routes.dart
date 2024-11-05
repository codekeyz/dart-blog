import 'dart:async';

import 'package:pharaoh/pharaoh_next.dart';

import '../routes/api.dart' as api;
import '../routes/web.dart' as web;

class RouteServiceProvider extends ServiceProvider {
  @override
  FutureOr<void> boot() {
    app.useRoutes(
      () => [
        /*|--------------------------------------------------------------------------
          | API Routes
          |--------------------------------------------------------------------------*/
        api.publicRoutes,
        api.authRoutes,

        /*|--------------------------------------------------------------------------
          | Web Routes
          |--------------------------------------------------------------------------*/
        Route.middleware('web').group('/', web.routes),
      ],
    );
  }
}
