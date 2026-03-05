import 'package:analyzer/dart/ast/ast.dart';
import 'package:blocz/_internal/visitors/FieldVisitor.dart';
import 'package:path/path.dart' as p;

import '../getProjectRootPath.dart';
import 'colors.dart';
import 'findNodes.dart';

// getInnerTypeAt
// eg: if Response<String,int>, at = 1 then return int, 0 then return String. default is 0
String getInnerTypeByPosition(
  TypeAnnotation returnType, {
  int at = 0,
  bool? useLexeme = true,
}) {
  if (returnType is! NamedType) {
    throw Exception(
      'Return type is not a NamedType, cannot extract class name.',
    );
  }

  NamedType typeToInspect = returnType;

  // Unwrap Future/FutureOr
  if (typeToInspect.name.toString() == 'Future' ||
      typeToInspect.name.toString() == 'FutureOr' ||
      typeToInspect.name.toString() == 'Stream') {
    if (typeToInspect.typeArguments != null &&
        typeToInspect.typeArguments!.arguments.isNotEmpty) {
      TypeAnnotation innerType;
      if (at > 0) {
        innerType = typeToInspect.typeArguments!.arguments[at];
      } else {
        innerType = typeToInspect.typeArguments!.arguments.first;
      }
      if (innerType is NamedType) {
        // print("innerType is NamedType");
        typeToInspect = innerType;
      } else {
        return innerType.toSource();
      }
    }
  }

  final result = switch (useLexeme) {
    true => typeToInspect.name.lexeme,
    _ => typeToInspect.toSource(),
  };
  print("[getInnerTypeByPosition] $result");
  return result;
}

// getInnerTypeLevel
// eg: if Response<User>, if level = 1 then return `User`, level = 0 then return Response<User>, defaults to 1
String? getInnerTypeByLevel(
  TypeAnnotation? returnType, {
  int level = 1,
  bool? useLexeme = false,
}) {
  if (returnType is! NamedType) {
    return null;
  }

  if (level <= 0) {
    return returnType.toSource();
  }

  NamedType typeToInspect = returnType;
  for (var i = 0; i < level; i++) {
    final typeArguments = typeToInspect.typeArguments;
    if (typeArguments == null || typeArguments.arguments.isEmpty) {
      return null;
    }
    final innerType = typeArguments.arguments.first;
    if (innerType is! NamedType) {
      return innerType.toSource();
    }
    typeToInspect = innerType;
  }

  final result = switch (useLexeme) {
    true => typeToInspect.name.lexeme,
    _ => typeToInspect.toSource(),
  };
  print("[getInnerTypeByLevel] $result");
  return result;
}

({String? type, TypeAnnotation? typeNode, bool isExists})
findProjectWideResponseType({
  required String innerType,
  required String filePath,
  required CompilationUnit initialUnit,
  required List<String> searchFields,
}) {
  final filesToSearch = <String>{filePath};
  // final fileDir = p.dirname(filePath);

  final partOfDirective = initialUnit.directives
      .whereType<PartOfDirective>()
      .firstOrNull;
  if (partOfDirective != null && partOfDirective.libraryName != null) {
    final libraryName = partOfDirective.libraryName!.name;
    final projectRoot = getProjectRootPath(scriptPath: filePath);

    // Search for the library file within the project root.
    final libraryFilePath = findLibraryFile(projectRoot!, libraryName);

    if (libraryFilePath != null) {
      final libraryDir = p.dirname(libraryFilePath);
      filesToSearch.add(libraryFilePath);
      final libraryUnit = parseFileByPath(libraryFilePath);
      if (libraryUnit != null) {
        for (final directive
            in libraryUnit.directives.whereType<PartDirective>()) {
          final partUri = directive.uri.stringValue;
          if (partUri != null) {
            final partPath = p.normalize(p.join(libraryDir, partUri));
            filesToSearch.add(partPath);
          }
        }
      }
    }
  }

  // print({filesToSearch.toList().join("\n")});
  ClassDeclaration? classNode;
  String? classDeclarationPath;
  for (final path in filesToSearch) {
    classNode = findClassInFile(path, innerType);
    if (classNode != null) {
      classDeclarationPath = path;
      printInfo(
        "--- [findProjectWideResponseType] found '${classDeclarationPath}' "
        "by findClassInFile at path $classDeclarationPath---",
      );
      break;
    }
  }

  // print(classNode);
  String? responseDataType;
  TypeAnnotation? dataTypeNode;
  bool isExists = false;

  for (final field in searchFields) {
    final fieldVisitor = FieldVisitor(fieldName: field);
    classNode?.accept(fieldVisitor);
    responseDataType = fieldVisitor.dataType;
    dataTypeNode = fieldVisitor.dataTypeNode;
    isExists = fieldVisitor.isExists;
    print("responseDataType $responseDataType");
    if (responseDataType != null /*&& dataTypeNode != null*/ ) {
      printInfo(
        "[findProjectWideResponseType] found '$field' type:$responseDataType",
      );
      break;
    }
    printWarning(
      '[findProjectWideResponseType] not found "$innerType.$field" in project',
    );
  }

  // print("$innerType");
  if (responseDataType == null /*|| dataTypeNode == null*/ ) {
    return (type: null, typeNode: null, isExists: false);
  }

  return (type: responseDataType, typeNode: dataTypeNode, isExists: isExists);
}
