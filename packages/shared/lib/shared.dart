enum AppEnvironment {
  local,
  staging,
  prod;
}

bool get isDebugMode {
  var isDebug = false;
  assert(() {
    isDebug = true;
    return true;
  }());
  return isDebug;
}

final appEnv = isDebugMode ? AppEnvironment.local : AppEnvironment.prod;
