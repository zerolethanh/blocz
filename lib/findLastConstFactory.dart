import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

int? findLastConstFactory(String pathOfSourceCode) {
  try {
    final lineNumber = _findLastConstFactoryLineNumber(pathOfSourceCode);
    // print('Found last const factory ending at line: ');
    // print(lineNumber);
    return lineNumber;
  } catch (e) {
    print('Error: $e');
  }
  return null;
}

int _findLastConstFactoryLineNumber(String filePath) {
  final file = File(filePath);

  if (!file.existsSync()) {
    throw FileSystemException('File not found', filePath);
  }

  final content = file.readAsStringSync();
  final parseResult = parseString(content: content, path: filePath);
  final visitor = _LastConstFactoryVisitor();
  parseResult.unit.visitChildren(visitor);

  if (visitor.lastConstFactoryNode != null) {
    return parseResult.lineInfo
        .getLocation(visitor.lastConstFactoryNode!.end)
        .lineNumber;
  }

  throw Exception('No const factory constructors found in $filePath');
}

class _LastConstFactoryVisitor extends RecursiveAstVisitor<void> {
  ConstructorDeclaration? lastConstFactoryNode;

  @override
  void visitConstructorDeclaration(ConstructorDeclaration constructor) {
    if (constructor.constKeyword != null &&
        constructor.factoryKeyword != null) {
      if (lastConstFactoryNode == null ||
          constructor.offset > lastConstFactoryNode!.offset) {
        lastConstFactoryNode = constructor;
      }
    }
    super.visitConstructorDeclaration(constructor);
  }
}
