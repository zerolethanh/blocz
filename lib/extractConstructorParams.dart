import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:floc_helper/_internal/colors.dart';
import 'package:floc_helper/_internal/typedef.dart';
import 'package:floc_helper/extractConstructorListFromClass.dart';
import 'package:floc_helper/getClassName.dart';

/// Extracts the source code of the parameter list from a constructor
/// in the given Dart file.
///
/// If [constructorName] is provided, it will look for a constructor with that
/// name. Otherwise, it will return the parameters of the first constructor found.
/// An empty string for [constructorName] targets the unnamed constructor.
JSONString extractConstructorParams(String codePath, [String? constructorName]) {
  final file = File(codePath);
  if (!file.existsSync()) {
    return '';
  }

  final content = file.readAsStringSync();
  final result = parseString(
    content: content,
    featureSet: FeatureSet.latestLanguageVersion(),
    throwIfDiagnostics: false,
  );

  if (constructorName == null || constructorName.isEmpty) {
    printWarning(
        "constructorName arg (--name) is not passed, get first constructor name from extractContructorListFromClass...");
    final firstContructorName = extractConstructorListFromClass(codePath).first;
    if (firstContructorName.isNotEmpty) {
      constructorName = firstContructorName
          .split(".")
          .last;
    }
    printSuccess("Got $firstContructorName ...done");
  } else if (constructorName.contains(".")) {
    constructorName = constructorName
        .split(".")
        .last;
  }

  final unit = result.unit;
  final visitor = _ConstructorVisitor(constructorName: constructorName);
  unit.accept(visitor);

  final value = visitor.constructorParameters ?? '';
  final className = getClassName(codePath);

  return toJSONStringResult(
      {
      "className": className,
      "constructorName": constructorName,
      "constructorParams": value
      }
  );
}

/// A visitor that finds a specific constructor and captures its parameter list.
class _ConstructorVisitor extends RecursiveAstVisitor<void> {
  final String? constructorName;
  String? constructorParameters;

  _ConstructorVisitor({this.constructorName});

  @override
  void visitConstructorDeclaration(ConstructorDeclaration constructor) {
    // Stop if we've already found a match.
    if (constructorParameters != null) return;

    // printWarning("node:${node.typeName}");
    final nodeName = constructor.name?.toString();

    if (constructorName == null) {
      // No name specified, so grab the very first constructor encountered.
      constructorParameters = constructor.parameters.toSource();
    } else if (constructorName!.isEmpty && nodeName == null) {
      // Empty name specified, so find the unnamed constructor.
      constructorParameters = constructor.parameters.toSource();
    } else if (nodeName == constructorName) {
      // Name specified, so find the matching named constructor.
      constructorParameters = constructor.parameters.toSource();
    } else if (constructor.typeName.toString() == constructorName) {
      // node.typeName is classname, as unnamed constructorName
      constructorParameters = constructor.parameters.toSource();
    }
  }
}
