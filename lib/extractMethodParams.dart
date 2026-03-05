import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:blocz/extractMethodListFromClass.dart';

import '_internal/typedef.dart';

JSONString? extractMethodParams(String filePath, [String? methodName]) {
  String? params;

  final methods = extractMethodListFromClass(filePath);

  if (methodName != null) {
    if (!methods.contains(methodName)) {
      throw Exception('Method "$methodName" not found in $filePath');
    }
    params = _extractSingleMethodParams(filePath, methodName);
    if (params == null) {
      throw Exception('Method "$methodName" not found in $filePath');
    }
  } else {
    methodName = methods.first;
    params = _extractSingleMethodParams(filePath, methodName);
  }
  // print(params);
  return JSONStringResult(
    data: params,
  ).toString();
}

String? _extractSingleMethodParams(String filePath, String methodName) {
  final file = File(filePath);
  if (!file.existsSync()) {
    throw Exception('File not found: $filePath');
  }

  final content = file.readAsStringSync();
  final result = parseString(
    content: content,
    featureSet: FeatureSet.latestLanguageVersion(),
    throwIfDiagnostics: false,
  );

  final unit = result.unit;
  final visitor = _MethodVisitor(methodName);
  unit.accept(visitor);

  return visitor.parameters;
}

class _MethodVisitor extends RecursiveAstVisitor<void> {
  final String methodName;
  String? parameters;

  _MethodVisitor(this.methodName);

  @override
  void visitMethodDeclaration(MethodDeclaration method) {
    // print("visitMethodDeclaration:");
    // print({methodName, node.name.lexeme});
    if (method.name.lexeme == methodName) {
      parameters = method.parameters?.toSource();
    }
  }
}
