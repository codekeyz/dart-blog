import 'package:yaroo/http/http.dart';
import 'package:yaroo/yaroo.dart';

final routes = <RouteDefinition>[
  Route.route(HTTPMethod.GET, '/', (req, res) => res.ok('Hello World 🤘')),
];
