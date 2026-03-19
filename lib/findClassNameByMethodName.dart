import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import 'package:blocz/extractProtoInfo.dart';
import '_internal/typedef.dart';

JSONString findClassNameByMethodName(String filePath, String methodName) {
  if (filePath.endsWith('.proto')) {
    return getProtoClassName(filePath, methodName);
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
  final visitor = _ClassFinderVisitor(methodName);
  unit.accept(visitor);

  return visitor.foundClassName ?? "";
}

class _ClassFinderVisitor extends RecursiveAstVisitor<void> {
  final String methodName;
  String? foundClassName;
  String? _currentClassName;

  _ClassFinderVisitor(this.methodName);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    _currentClassName = node.name.toString();
    super.visitClassDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    if (node.name.toString() == methodName) {
      foundClassName = _currentClassName;
    }
  }
}
