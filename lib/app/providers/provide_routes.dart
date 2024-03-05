import 'dart:async';

import 'package:backend/backend.dart';
import 'package:pharaoh/next/http.dart';
import 'package:pharaoh/next/router.dart';

class RouteServiceProvider extends ServiceProvider {
  @override
  FutureOr<void> boot() {
    app.useRoutes(
      () => [
        Route.group('api', [
          // Public Routes
          Route.post('/auth/login', (AuthController, #login)),
          Route.post('/auth/register', (AuthController, #register)),
          Route.get('/users/<userId>', (UserController, #show)),
          Route.group('articles', [
            Route.get('/', (ArticleController, #index)),
            Route.get('/<articleId>', (ArticleController, #show)),
          ]),

          // Authenticated routes
          Route.middleware('api:auth').routes([
            Route.group('users', [
              Route.get('/', (UserController, #index)),
              Route.get('/me', (UserController, #currentUser)),
            ]),
            Route.group('articles', [
              Route.post('/', (ArticleController, #create)),
              Route.put('/<articleId>', (ArticleController, #update)),
              Route.delete('/<articleId>', (ArticleController, #delete)),
            ]),
          ]),
        ]),
      ],
    );
  }
}
