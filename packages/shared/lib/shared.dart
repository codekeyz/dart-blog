enum AppEnvironment {
  local,
  staging,
  prod;

  const AppEnvironment();

  Uri get apiURL => switch (this) {
        AppEnvironment.prod => Uri.https('blog-backend.globeapp.dev'),
        _ => Uri.http('localhost:3000'),
      };
}

final isDebugMode = const bool.fromEnvironment("dart.vm.product") == false;

bool get isTestMode {
  var isDebug = false;
  assert(() {
    isDebug = true;
    return true;
  }());
  return isDebug;
}

final appEnv = isTestMode || isDebugMode ? AppEnvironment.local : AppEnvironment.prod;
