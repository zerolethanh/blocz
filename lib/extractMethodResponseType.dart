import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:blocz/_internal/typedef.dart';

/// Extracts the return type of a given method from a Dart file.
///
/// Returns the source string of the return type.
/// Throws an exception if the method is not found.
/// Returns 'dynamic' if the method has no explicit return type.
JSONString extractMethodResponseType(String filePath, String methodName) {
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
  final visitor = _MethodResponseTypeVisitor(methodName);
  unit.accept(visitor);

  if (visitor.returnType == null) {
    throw Exception('Method "$methodName" not found in $filePath');
  }

  return visitor.returnType!;
}

class _MethodResponseTypeVisitor extends RecursiveAstVisitor<void> {
  final String methodName;
  String? returnType;

  _MethodResponseTypeVisitor(this.methodName);

  @override
  void visitMethodDeclaration(MethodDeclaration method) {
    if (method.name.lexeme == methodName) {
      if (method.returnType != null) {
        returnType = method.returnType!.toSource();
      } else {
        // Methods without an explicit return type implicitly have a return type of 'dynamic'.
        returnType = 'dynamic';
      }
    }
  }
}
