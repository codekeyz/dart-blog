import 'dart:io';

import 'package:type_analyzer/type_analyzer.dart' as type_analyzer;

void main(List<String> arguments) {
  type_analyzer.EndpointsAnalyzer(Directory.current).analyze();
}
