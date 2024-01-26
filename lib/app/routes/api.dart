import 'package:backend/src/controllers/controllers.dart';
import 'package:yaroo/yaroo.dart';

List<RouteDefinition> routes = [
  /// Users
  Route.group('users', [
    Route.get('/', (UserController, #index)),
    Route.get('/me', (UserController, #currentUser)),
  ]),

  /// Articles
  Route.group('articles', [
    Route.post('/', (ArticleController, #create)),
    Route.put('/<articleId>', (ArticleController, #update)),
    Route.delete('/<articleId>', (ArticleController, #delete)),
  ]),
];
