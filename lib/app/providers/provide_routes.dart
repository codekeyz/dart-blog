import 'dart:async';

import 'package:yaroo/http/http.dart';
import 'package:yaroo/yaroo.dart';

import '../../src/controllers/controllers.dart';
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
        Route.group('api').routes([
          Route.post('/auth/login', (AuthController, #login)),
          Route.post('/auth/register', (AuthController, #register)),

          Route.get('/users/<userId>', (UserController, #show)),

          /// get articles and detail without auth
          Route.group('articles').routes([
            Route.get('/', (ArticleController, #index)),
            Route.get('/<articleId>', (ArticleController, #show)),
          ]),
        ]),
        Route.middleware('auth:api').group('api').routes(api.routes),

        /*|--------------------------------------------------------------------------
          | Web Routes
          |--------------------------------------------------------------------------*/
        Route.middleware('web').group('/').routes(web.routes),
      ],
    );
  }
}
