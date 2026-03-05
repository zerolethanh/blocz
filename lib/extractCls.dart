import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:floc_helper/_internal/typedef.dart';

/// Extracts the source code of the first class declaration found in the given Dart file.
JSONString extractCls(String codePath) {
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

  final unit = result.unit;
  final visitor = _ClassVisitor();
  unit.accept(visitor);

  final source = visitor.classSource ?? '';
  // print(source);
  return source;
}

/// A visitor that finds the first class in an AST and captures its source code.
class _ClassVisitor extends RecursiveAstVisitor<void> {
  String? classSource;

  @override
  void visitClassDeclaration(ClassDeclaration cls) {
    classSource ??= cls.toSource();
  }
}
