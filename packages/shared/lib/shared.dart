enum AppEnvironment {
  local,
  staging,
  prod;

  const AppEnvironment();

  Uri get apiURL => switch (this) {
        AppEnvironment.prod => Uri.https('blog-backend-369d.globeapp.dev'),
        _ => Uri.http('localhost:3000'),
      };

  Uri get frontendURL => switch (this) {
        AppEnvironment.prod => Uri.https('blog-frontend.globeapp.dev'),
        _ => Uri.http('localhost:60964'),
      };
}

final isDebugMode = const bool.fromEnvironment("dart.vm.product") == false;

const defaultArticleImage = 'https://images.pexels.com/photos/261763/pexels-photo-261763.jpeg';

bool get isTestMode {
  var isDebug = false;
  assert(() {
    isDebug = true;
    return true;
  }());
  return isDebug;
}

final appEnv = isTestMode || isDebugMode ? AppEnvironment.local : AppEnvironment.prod;
