import 'package:yaroo/http/http.dart';
import 'package:yaroo/yaroo.dart';

List<RouteDefinition> routes = [
  Route.handler(HTTPMethod.GET, '/', (req, res) {
    return res.render('home', {'app_name': 'Yaroo', 'app_version': '1.0.0'});
  }),
  Route.handler(HTTPMethod.GET, '/login', (req, res) => res.render('login')),
  Route.handler(HTTPMethod.POST, '/login', (req, res) => res.unauthorized()),
];
