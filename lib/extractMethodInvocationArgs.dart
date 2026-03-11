import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '_internal/typedef.dart';

/// Extracts the argument list of a method invocation.
///
/// If [methodName] is provided, it finds the first invocation of that method.
/// Returns a JSON string with the argument list source, e.g., `{"data": "(id, name: event.name)"}`.
JSONString? extractMethodInvocationArgs(String filePath, String? methodName) {
  if (methodName == null) {
    return null;
  }
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
  final visitor = _MethodInvocationVisitor(methodName);
  unit.accept(visitor);

  if (visitor.arguments == null) {
    return null;
  }

  return JSONStringResult(data: visitor.arguments).toString();
}

class _MethodInvocationVisitor extends RecursiveAstVisitor<void> {
  final String methodName;
  String? arguments;

  _MethodInvocationVisitor(this.methodName);

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (arguments != null) return; // Only take the first match

    if (node.methodName.name == methodName) {
      arguments = node.argumentList.toSource();
    }
    super.visitMethodInvocation(node);
  }
}
