import 'dart:io'; // Required for file operations

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

int? findLast_On_LineNumber(String pathOfSourceCode) {
  // Replace this with your actual file path
  // final pathOfSourceCode = 'lib/bloc/product_test_bloc.dart';

  try {
    final lineNumber = _findLastOnLineNumber(pathOfSourceCode);
    // print('Found last on<...> ending at line: $lineNumber');
    // print(lineNumber);
    return lineNumber;
  } catch (e) {
    print('Error: $e');
  }
  return null;
}

int _findLastOnLineNumber(String filePath) {
  final file = File(filePath);

  if (!file.existsSync()) {
    throw FileSystemException('File not found', filePath);
  }

  // 1. Read the file content
  final content = file.readAsStringSync();

  // 2. Parse the content into an AST
  // passing 'path' helps the analyzer report errors correctly if needed
  final parseResult = parseString(content: content, path: filePath);

  // 3. Visit the nodes to find method invocations
  final visitor = _LastOnMethodVisitor();
  parseResult.unit.visitChildren(visitor);

  // 4. Check results
  if (visitor.lastOnNode != null) {
    // 5. Calculate line number from the 'end' offset
    return parseResult.lineInfo.getLocation(visitor.lastOnNode!.end).lineNumber;
  }

  throw Exception('No on<...>() calls found in $filePath');
}

class _LastOnMethodVisitor extends RecursiveAstVisitor<void> {
  MethodInvocation? lastOnNode;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.methodName.name == 'on') {
      // Keep updating lastOnNode if we find an 'on' call with a higher offset
      if (lastOnNode == null || node.offset > lastOnNode!.offset) {
        lastOnNode = node;
      }
    }
    super.visitMethodInvocation(node);
  }
}
