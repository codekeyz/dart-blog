import 'package:yaroo/yaroo.dart';
import 'package:zomato/src/controllers/controllers.dart';

List<RouteDefinition> routes = [
  Route.group('users').routes([
    Route.get('/', (UserController, #index)),
    Route.get('/<userId>', (UserController, #show)),
  ]),

  /// auth routes
  Route.group('auth').routes([
    Route.post('/login', (AuthController, #login)),
    Route.post('/register', (AuthController, #register)),
  ])
];
