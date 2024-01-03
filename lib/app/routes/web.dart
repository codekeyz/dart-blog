import 'package:yaroo/http/http.dart';
import 'package:yaroo/yaroo.dart';

final routes = <RouteDefinition>[
  Route.handler(HTTPMethod.GET, '/', (_, req, res) => res.render('index')),
];
