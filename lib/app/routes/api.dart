import 'package:backend/src/controllers/controllers.dart';
import 'package:yaroo/yaroo.dart';

List<RouteDefinition> routes = [
  Route.group('users').routes([
    Route.get('/', (UserController, #index)),
    Route.get('/<userId>', (UserController, #show)),
  ]),
];
