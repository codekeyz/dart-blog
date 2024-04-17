bool get isDebugMode {
  var isDebug = false;
  assert(() {
    isDebug = true;
    return true;
  }());
  return isDebug;
}
