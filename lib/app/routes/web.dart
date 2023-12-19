import 'package:yaroo/http/http.dart';
import 'package:yaroo/yaroo.dart';

List<RouteDefinition> routes = [
  Route.handler(HTTPMethod.GET, '/', (req, res) {
    return res.render('welcome', {'app_name': 'Yaroo', 'app_version': '1.0.0'});
  }),
];
