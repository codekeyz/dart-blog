import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';
import 'package:grammer/grammer.dart';
import 'package:collection/collection.dart';

const yaroormIdentifier = 'package:yaroorm/src/database/entity/entity.dart';

class EndpointsAnalyzer {
  final AnalysisContextCollection collection;

  /// Create a new [EndpointsAnalyzer], containing a
  /// [AnalysisContextCollection] that analyzes all dart files in the
  /// provided [endpointDirectory].
  EndpointsAnalyzer(Directory endpointDirectory)
      : collection = AnalysisContextCollection(
          includedPaths: [
            path.join(endpointDirectory.path, 'lib/src/models'),
            // path.join(endpointDirectory.path, 'lib/src/controllers'),
            // path.join(endpointDirectory.path, 'lib/src/services'),
          ],
          resourceProvider: PhysicalResourceProvider.INSTANCE,
        );

  void analyze() async {
    await for (var (library, filePath, _) in _libraries) {
      final libraryElement = library.element;
      final topElements = libraryElement.topLevelElements;
      final classElements = topElements.whereType<ClassElement>();

      if (classElements.isEmpty) return;

      analyzeClassElement(libraryElement, filePath, classElements.first);
    }
  }

  void analyzeClassElement(
    LibraryElement libElement,
    String filePath,
    ClassElement classElement,
  ) async {
    final fields = classElement.fields.where(allowedTypes).toList();

    final className = classElement.name;
    final meta = classElement.metadata
        .firstWhere((e) => e.element?.library?.identifier == 'package:yaroorm/src/database/entity/entity.dart')
        .computeConstantValue();
    final tableName = meta!.getField('name')?.toStringValue() ?? classElement.name.snakeCase.toPlural().first;

    final primaryKey = getEntityField(fields, 'PrimaryKey');
    final createdAt = getEntityField(fields, 'CreatedAtColumn');
    final updatedAt = getEntityField(fields, 'UpdatedAtColumn');

    final timestampsEnabled = (createdAt ?? updatedAt) != null;
    final updatableFields = fields.where((e) => ![primaryKey, createdAt].contains(e));

    final primaryConstructor = classElement.constructors.firstWhereOrNull((e) => e.name == "");
    if (primaryConstructor == null) {
      throw '$className Entity does not have a default constructor';
    }

    if (primaryKey == null) {
      throw Exception("$className Entity doesn't have primary key");
    }

    final fieldNames = fields.map((e) => e.name);
    final contructorArgs = primaryConstructor.children;
    final notAllowedProps = contructorArgs.where((e) => !fieldNames.contains(e.name));
    if (notAllowedProps.isNotEmpty) {
      throw Exception(
          'These props are not allowed in $className Entity default constructor: ${notAllowedProps.join(', ')}');
    }

    String fieldToString(FieldElement e) {
      final symbol = '#${e.name}';
      return '''DBEntityField(
               "${e.name}",
               ${e.type.getDisplayString(withNullability: false)}, 
               $symbol,
               nullable: ${libElement.typeSystem.isNullable(e.type)},
               primaryKey: ${e == primaryKey}
              )''';
    }

    final typeDataName = '${className.toLowerCase()}TypeData';

    final library = Library((b) => b
      ..comments.add('ignore_for_file: non_constant_identifier_names')
      ..body.addAll([
        Directive.partOf(path.basename(filePath)),
        Method((m) => m
          ..name = '${classElement.name.pascalCase}Query'
          ..returns = refer('Query<$className>')
          ..type = MethodType.getter
          ..lambda = true
          ..body = Code('DB.query<$className>()')),
        Method((m) => m
          ..name = '${classElement.name.pascalCase}Schema'
          ..returns = refer('CreateSchema')
          ..lambda = true
          ..type = MethodType.getter
          ..body = Code('Schema.fromEntity<$className>()')),
        Method((m) => m
          ..name = typeDataName
          ..returns = refer('DBEntity<$className>')
          ..type = MethodType.getter
          ..lambda = true
          ..body = Code(
            '''DBEntity<$className>(
                "$tableName", 
                timestampsEnabled: $timestampsEnabled, 
                columns: ${fields.map(fieldToString).toList()},
                mirror: _\$${className}EntityMirror.new,
                build: (args) => ${_generateConstructorCode(className, primaryConstructor)}
                ,)''',
          )),
        Class(
          (b) => b
            ..name = '_\$${className}Entity'
            ..extend = refer('Entity<$className>')
            ..methods.addAll([
              Method((m) => m
                ..name = '_instance'
                ..returns = refer(className)
                ..type = MethodType.getter
                ..lambda = true
                ..body = Code('this as $className')),
              Method((m) => m
                ..name = 'update'
                ..returns = refer('Future<$className>')
                ..modifier = MethodModifier.async
                ..optionalParameters.addAll([
                  ...updatableFields.map((e) => Parameter((m) => m
                    ..name = e.name
                    ..required = false
                    ..named = true
                    ..type = refer('${e.type.getDisplayString(withNullability: false)}?'))),
                ])
                ..body = Code('return _instance;')),
            ]),
        ),
        Class(
          (b) => b
            ..name = '_\$${className}EntityMirror'
            ..extend = refer('EntityMirror<$className>')
            ..constructors.add(Constructor(
              (b) => b
                ..constant = true
                ..requiredParameters.add(Parameter((p) => p
                  ..toSuper = true
                  ..name = 'instance')),
            ))
            ..methods.addAll([
              Method((m) => m
                ..name = 'get'
                ..annotations.add(CodeExpression(Code('override')))
                ..requiredParameters.add(Parameter((p) => p
                  ..name = 'field'
                  ..type = refer('Symbol')))
                ..returns = refer('Object?')
                ..body = Code('''
return switch(field) {
  ${fields.map((e) => '''
  #${e.name} => instance.${e.name}
''').join(',')},
  _ => throw Exception('Unknown property \$field'),
};
''')),
            ]),
        ),
      ]));

    final actualFilePath = path.basename(filePath).replaceFirst('.dart', '.entity.dart');

    final df = path.join(path.dirname(filePath), actualFilePath);

    final emitter = DartEmitter();

    await File(df).writeAsString(
      DartFormatter().format('${library.accept(emitter)}'),
    );
  }

  Stream<(ResolvedLibraryResult, String, String)> get _libraries async* {
    for (var context in collection.contexts) {
      final analyzedDartFiles = context.contextRoot.analyzedFiles().where((path) =>
          path.endsWith('.dart') &&
          !path.endsWith('_test.dart') &&
          !path.endsWith('.g.dart') &&
          !path.endsWith('.e.dart'));

      for (var filePath in analyzedDartFiles) {
        var library = await context.currentSession.getResolvedLibrary(filePath);
        if (library is ResolvedLibraryResult) {
          yield (library, filePath, context.contextRoot.root.path);
        }
      }
    }
  }
}

bool allowedTypes(FieldElement field) {
  return field.getter?.isSynthetic ?? false;
}

String _generateConstructorCode(String className, ConstructorElement constructor) {
  final sb = StringBuffer()..write('$className(');

  final normalParams = constructor.type.normalParameterNames;
  final namedParams = constructor.type.namedParameterTypes.keys;

  if (normalParams.isNotEmpty) {
    sb
      ..write(normalParams.map((name) => 'args[#$name]').join(','))
      ..write(',');
  }

  if (namedParams.isNotEmpty) {
    sb
      ..writeln(namedParams.map((name) => '$name: args[#$name]').join(', '))
      ..write(',');
  }

  return (sb..write(')')).toString();
}

FieldElement? getEntityField(List<FieldElement> fields, String type) {
  return fields.firstWhereOrNull((f) {
    return f.metadata.firstWhereOrNull((e) =>
            e.element?.library?.identifier == yaroormIdentifier &&
            (e.element is PropertyAccessorElement) &&
            (e.element as PropertyAccessorElement).returnType.toString() == type) !=
        null;
  });
}
