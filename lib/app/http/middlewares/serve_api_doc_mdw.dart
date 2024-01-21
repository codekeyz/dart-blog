import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';
import 'package:yaroo/http/http.dart';

class ServeApiSwaggerDoc extends Middleware {
  late HandlerFunc _handlerFunc;

  ServeApiSwaggerDoc() {
    final shelfSwagger = SwaggerUI('swagger.json', title: app.name);
    _handlerFunc = useShelfMiddleware(shelfSwagger.call);
  }

  @override
  HandlerFunc get handler => _handlerFunc;
}
