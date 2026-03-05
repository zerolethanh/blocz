import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

List<String> extractMethodListFromClass(String filePath, [String? className]) {
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

  final compilationUnit = result.unit;
  final visitor = _MethodVisitor(className);
  compilationUnit.accept(visitor);

  final values = visitor.methods.toSet().toList();
  // print(values.join("\n"));
  return values;
}

class _MethodVisitor extends GeneralizingAstVisitor<void> {
  final String? _className;
  final List<String> methods = [];
  String? _currentClassName;

  _MethodVisitor(this._className);

  @override
  void visitClassDeclaration(ClassDeclaration cls) {
    _currentClassName = cls.name.toString();
    if (_className == null || _currentClassName == _className) {
      super.visitClassDeclaration(cls);
    }
  }

  @override
  void visitMethodDeclaration(MethodDeclaration method) {
    if (_className == null || _currentClassName == _className) {
      if (method.isGetter || method.isSetter || method.isOperator) {
        return;
      }
      final methodName = method.name.toString();
      if (methodName != _currentClassName) {
        methods.add(methodName);
      }
    }
  }
}
