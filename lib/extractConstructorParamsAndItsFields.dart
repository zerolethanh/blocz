import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';
import 'package:floc_helper/_internal/typedef.dart';
import 'package:floc_helper/extractConstructorParams.dart';

/// Extracts a map of constructor parameter names to their corresponding field details.
///
/// The key of the returned map is the parameter name.
/// The value is another map containing:
///   - 'fieldName': The name of the class field.
///   - 'fieldSource': The full source code of the field declaration, including comments.
///
/// [codePath] is the path to the Dart source file.
/// If [constructorName] is provided, it looks for a constructor with that name.
JSONString extractConstructorParamsAndItsFields(
    String codePath, [String? constructorName]) {
  final file = File(codePath);
  if (!file.existsSync()) {
    throw FileSystemException('File not found', codePath);
  }

  final content = file.readAsStringSync();
  final result = parseString(
    content: content,
    featureSet: FeatureSet.latestLanguageVersion(),
    throwIfDiagnostics: false,
  );

  final classNode = result.unit.declarations.whereType<ClassDeclaration>().firstOrNull;
  if (classNode == null) {
    return jsonEncode({
      'constructorName': null,
      'constructorParams': [],
      'fieldsAndTypes': []
    });
  }

  final constructorParamsToFieldDetails = <String, Map<String, String>>{};

  final constructors = classNode.members.whereType<ConstructorDeclaration>();
  if (constructors.isEmpty) {
    return jsonEncode({
      'constructorName': null,
      'constructorParams': [],
      'fieldsAndTypes': []
    });
  }

  final constructor = constructorName == null
      ? constructors.first
      : constructors.firstWhere(
          (c) => c.name?.toString() == constructorName,
          orElse: () => throw Exception(
              'Constructor "$constructorName" not found in class "${classNode.name}"'),
        );

  // Helper to find the full source and name of a field
  Map<String, String>? findFieldDetails(String fieldName) {
    final fieldNode = classNode.members
        .whereType<FieldDeclaration>()
        .firstWhereOrNull(
            (field) => field.fields.variables
                .any((variable) => variable.name.toString() == fieldName),
            );
    if (fieldNode != null) {
      return {
        'fieldName': fieldName,
        'fieldSource': fieldNode.toSource(),
      };
    }
    return null;
  }

  // Handle field formal parameters (e.g., this.field)
  for (final parameter in constructor.parameters.parameters) {
    final FormalParameter actualParam =
        (parameter is DefaultFormalParameter) ? parameter.parameter : parameter;

    if (actualParam is FieldFormalParameter) {
      final fieldName = actualParam.name.toString();
      final fieldDetails = findFieldDetails(fieldName);
      if (fieldDetails != null) {
        constructorParamsToFieldDetails[fieldName] = fieldDetails;
      }
    }
  }

  // Handle constructor initializers (e.g., : field = param)
  for (final initializer in constructor.initializers) {
    if (initializer is ConstructorFieldInitializer) {
      final fieldName = initializer.fieldName.toString();
      final paramName = initializer.expression.toString();
      final fieldDetails = findFieldDetails(fieldName);
      if (fieldDetails != null) {
        constructorParamsToFieldDetails[paramName] = fieldDetails;
      }
    }
  }

  final constructorParams = <String>[];
  final fieldsAndTypes = <String>[];
  final processedFields = <String>{}; // To avoid duplicate fields

  for (final entry in constructorParamsToFieldDetails.entries) {
    final paramName = entry.key;
    final fieldDetails = entry.value;
    final fieldName = fieldDetails['fieldName'];
    final fieldSource = fieldDetails['fieldSource'];

    if (fieldName == null || fieldSource == null) {
      continue;
    }

    // Find the corresponding parameter to get its full source
    final parameter = constructor.parameters.parameters.firstWhereOrNull((p) {
      final actualParam = (p is DefaultFormalParameter) ? p.parameter : p;
      return actualParam.name?.toString() == paramName;
    });

    if (parameter != null) {
      constructorParams.add(parameter.toSource());
    }

    if (!processedFields.contains(fieldName)) {
      fieldsAndTypes.add(fieldSource);
      processedFields.add(fieldName);
    }
  }

  // final finalConstructorName = constructor.name == null
  //     ? constructor.typeName.toString()
  //     : '${constructor.typeName.toString()}.${constructor.name}';

  final params = jsonDecode(
      extractConstructorParams(codePath, constructorName)
  );
  return jsonEncode({
    ...params,
    'fieldsAndTypes': fieldsAndTypes,
  });
}
