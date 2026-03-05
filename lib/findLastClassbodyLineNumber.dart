import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

int? findLastClassbodyLineNumber(String pathOfSourceCode) {
  try {
    final lineNumber = _findLastClassbodyLineNumber(pathOfSourceCode);
    return lineNumber;
  } catch (e) {
    // Error handling can be improved, for now just returning null
  }
  return null;
}

int _findLastClassbodyLineNumber(String filePath) {
  final file = File(filePath);

  if (!file.existsSync()) {
    throw FileSystemException('File not found', filePath);
  }

  // 1. Read the file content
  final content = file.readAsStringSync();

  // 2. Parse the content into an AST
  final parseResult = parseString(content: content, path: filePath);

  // 3. Visit the nodes to find the last class declaration
  final visitor = _LastClassVisitor();
  parseResult.unit.visitChildren(visitor);

  // 4. Check results
  if (visitor.lastClassNode != null) {
    // 5. Calculate line number from the 'end' offset of the closing brace
    final classNode = visitor.lastClassNode!;
    final lineNumber = parseResult.lineInfo
        .getLocation(classNode.rightBracket.end)
        .lineNumber;
    print('Found last class declaration ending at line: ');
    print(lineNumber);
  }

  throw Exception('No class declarations found in $filePath');
}

class _LastClassVisitor extends RecursiveAstVisitor<void> {
  ClassDeclaration? lastClassNode;

  @override
  void visitClassDeclaration(ClassDeclaration cls) {
    // Keep updating lastClassNode if we find a class with a higher offset
    if (lastClassNode == null || cls.offset > lastClassNode!.offset) {
      lastClassNode = cls;
    }
    super.visitClassDeclaration(cls);
  }
}
