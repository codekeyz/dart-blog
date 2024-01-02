import 'package:yaroo/http/http.dart';

class JinJaViewProvider extends ServiceProvider {
  static Map<String, String> pathAlias = {'auth': 'pages/auth'};

  String get fileExtension => 'j2';

  String get viewsDir => 'public';

  @override
  void register() {
    final environment = Environment(
      autoReload: false,
      trimBlocks: true,
      leftStripBlocks: true,
      loader: FileSystemLoader(paths: [viewsDir], extensions: {fileExtension}),
    );
    app.useViewEngine(JinjaViewEngine(environment, fileExt: fileExtension));
  }
}

extension ViewRender on Response {
  Response view(String name, [Map<String, dynamic> data = const {}]) {
    final filePath = name.split('.').map((e) => JinJaViewProvider.pathAlias[e] ?? e).join('/');
    return render(filePath, data);
  }
}
