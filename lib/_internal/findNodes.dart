import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:path/path.dart' as p;

class FindClassInProjectResult {
  final ClassDeclaration classNode;
  final String filePath;

  FindClassInProjectResult(this.classNode, this.filePath);
}

/// Recursively searches a directory for a file containing a specific library directive.
String? findLibraryFile(String searchDir, String libraryName) {
  final dir = Directory(searchDir);
  if (!dir.existsSync()) return null;

  final searchPattern = 'library $libraryName;';

  final entries = dir.listSync(recursive: true, followLinks: false);
  for (final entity in entries) {
    if (entity is File && entity.path.endsWith('.dart')) {
      try {
        final content = entity.readAsStringSync();
        if (content.contains(searchPattern)) {
          return entity.path;
        }
      } catch (e) {
        // Ignore files that can't be read.
      }
    }
  }
  return null;
}

ClassDeclaration? findClassInProject(String projectRoot, String className) {
  final result = findClassInProjectWithFilePath(projectRoot, className);
  return result?.classNode;
}

FindClassInProjectResult? findClassInProjectWithFilePath(
    String projectRoot, String className) {
  final libDir = Directory(p.join(projectRoot, 'lib'));
  if (!libDir.existsSync()) return null;

  final files = libDir.listSync(recursive: true, followLinks: false);

  for (final file in files) {
    if (file is File && file.path.endsWith('.dart')) {
      final classNode = findClassInFile(file.path, className);
      if (classNode != null) {
        return FindClassInProjectResult(classNode, file.path);
      }
    }
  }

  return null;
}

CompilationUnit? parseFileByPath(String filePath) {
  final file = File(filePath);
  if (!file.existsSync()) return null;
  final content = file.readAsStringSync();
  return parseString(content: content, throwIfDiagnostics: false).unit;
}

ClassDeclaration? findClassInFile(String filePath, String className) {
  final unit = parseFileByPath(filePath);
  if (unit == null) return null;
  final visitor = _ClassVisitor(className);
  unit.accept(visitor);
  return visitor.classNode;
}

class _ClassVisitor extends RecursiveAstVisitor<void> {
  final String className;
  ClassDeclaration? classNode;

  _ClassVisitor(this.className);

  @override
  void visitClassDeclaration(ClassDeclaration cls) {
    if (cls.namePart.toSource() == className) {
      classNode = cls;
    }
  }
}
