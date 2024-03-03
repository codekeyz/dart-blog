import 'package:backend/src/controllers/controllers.dart';
import 'package:pharaoh/pharaoh_next.dart';

final publicRoutes = Route.group('api', [
  Route.post('/auth/login', (AuthController, #login)),
  Route.post('/auth/register', (AuthController, #register)),

  Route.get('/users/<userId>', (UserController, #show)),

  /// get articles and detail without auth
  Route.group('articles', [
    Route.get('/', (ArticleController, #index)),
    Route.get('/<articleId>', (ArticleController, #show)),
  ]),
]);

final authRoutes = Route.middleware('api:auth').group('api', [
  // Users
  Route.group('users', [
    Route.get('/', (UserController, #index)),
    Route.get('/me', (UserController, #currentUser)),
  ]),

  // Articles
  Route.group('articles', [
    Route.post('/', (ArticleController, #create)),
    Route.put('/<articleId>', (ArticleController, #update)),
    Route.delete('/<articleId>', (ArticleController, #delete)),
  ]),
]);
