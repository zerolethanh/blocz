import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

List<String> extractConstructorListFromClass(String filePath,
    [String? className]) {
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
  final visitor = _ConstructorVisitor(className);
  compilationUnit.accept(visitor);

  return visitor.constructors;
}

class _ConstructorVisitor extends GeneralizingAstVisitor<void> {
  final String? _className;
  _ConstructorVisitor(this._className);

  String? _currentClassName;
  final List<String> constructors = [];

  @override
  void visitClassDeclaration(ClassDeclaration cls) {
    _currentClassName = cls.namePart.toString();
    if (_className == null || _currentClassName == _className) {
      super.visitClassDeclaration(cls);
    }
  }

  @override
  void visitConstructorDeclaration(ConstructorDeclaration constructor) {
    if (_className == null || _currentClassName == _className) {
      final constructorName = constructor.name?.toString();
      if (constructorName != null) {
        constructors.add('$_currentClassName.$constructorName');
      } else {
        constructors.add('$_currentClassName');
      }
    }
  }
}
