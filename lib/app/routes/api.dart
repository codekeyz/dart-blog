import 'package:yaroo/yaroo.dart';
import 'package:zomato/src/controllers/controllers.dart';

List<RouteDefinition> routes = [
  Route.group('users').routes([
    Route.get('/', (UserController, #index)),
    Route.post('/', (UserController, #create)),
    Route.get('/<userId|number>', (UserController, #show)),
    Route.put('/<userId|number>', (UserController, #update)),
    Route.delete('/<userId|number>', (UserController, #delete)),
  ]),
];
