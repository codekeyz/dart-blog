import 'package:yaroo/yaroo.dart';
import 'package:zomato/src/controllers/controllers.dart';

List<RouteDefinition> routes = [
  Route.group('users').routes([
    Route.get('/', (UserController, #index)),
    Route.post('/', (UserController, #create)),
    Route.get('/<userId>', (UserController, #show)),
    Route.put('/<userId>', (UserController, #update)),
    Route.delete('/<userId>', (UserController, #delete)),
  ]),
];
