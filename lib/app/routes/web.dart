import 'package:yaroo/http/http.dart';
import 'package:yaroo/yaroo.dart';

final routes = <RouteDefinition>[
  Route.handler(HTTPMethod.ALL, '*', (_, req, res) => res.ok('hey 🚀')),
];
