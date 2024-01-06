import 'package:backend/src/controllers/controllers.dart';
import 'package:yaroo/yaroo.dart';

List<RouteDefinition> routes = [
  /// Users
  Route.group('users').routes([
    Route.get('/', (UserController, #index)),
    Route.get('/me', (UserController, #currentUser)),
    Route.get('/<userId>', (UserController, #show)),
  ]),

  /// Articles
  Route.group('articles').routes([
    Route.post('/', (ArticleController, #create)),
    Route.put('/<articleId>', (ArticleController, #update)),
    Route.delete('/<articleId>', (ArticleController, #delete)),
  ]),
];
