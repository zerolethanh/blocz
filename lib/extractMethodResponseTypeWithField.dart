import 'dart:core';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:blocz/_internal/find_nodes.dart';
import 'package:blocz/_internal/getInnerType.dart';
import 'package:blocz/get_project_root_path.dart';
import 'package:blocz/import_clause_to_path.dart';
import 'package:path/path.dart' as p;

import '_internal/colors.dart';
import '_internal/projectContext.dart';
import '_internal/visitors/FieldVisitor.dart';

Future<void> main() async {
  // final result = await extractMethodResponseTypeWithField(
  //   "/Users/lethanh/StudioProjects/ddd/packages/openapi/lib/api/orders_api.dart",
  //   "v1OrdersByCouponCodeGet",
  //   "data",
  // );
  // printSuccess(jsonEncode(result));
}

/// Extracts the type of the 'data' field from a method's response type.
Future<Map<String, dynamic>> extractMethodResponseTypeWithField(
  String filePath,
  String methodName,
  dynamic searchFields, [
  bool returnRawType = true,
  bool stripFutureType = true,
]) async {
  searchFields =
      searchFields.replaceAll(RegExp(r'\s+'), "").split(",") as List<String>;
  if (searchFields == null ||
      searchFields is List<String> && searchFields.isEmpty) {
    searchFields = ["data", "body"];
  }
  // }
  // printInfo("search declaration for field '$searchFields'");
  final initialUnit = parseFileByPath(filePath);
  if (initialUnit == null) {
    throw Exception('File not found or failed to parse: $filePath');
  }

  final methodVisitor = _MethodVisitor(methodName);
  initialUnit.accept(methodVisitor);
  final returnType = methodVisitor.returnType;
  if (returnType == null) {
    throw Exception(
      'Method "$methodName" not found or has no return type in $filePath',
    );
  }
  if (returnRawType) {
    // print(" raw return type: $returnType");
    if (stripFutureType) {
      return {"responseDataType": unwrapFuture(returnType.toString())};
    }
    return {"responseDataType": returnType.toString()};
  }

  final innerType = getInnerTypeByPosition(returnType, at: 0);
  if (innerType == "void") {
    return {"responseDataType": innerType};
  }

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
      printInfo("found by findClassInFile ($classDeclarationPath}");
      break;
    }
  }

  // TODO: bellow maybe never reach
  if (classNode == null) {
    final projectRoot = getProjectRootPath(scriptPath: filePath);
    if (projectRoot != null) {
      final result = findClassInProjectWithFilePath(projectRoot, innerType);
      if (result != null) {
        classNode = result.classNode;
        classDeclarationPath = result.filePath;
        printInfo(
          "found in getProjectRootPath+findClassInProjectWithFilePath ($classDeclarationPath)",
        );
      }
    }
  }
  // END TODO

  bool foundBy_findClassDeclarationWithHttpResponse = false;
  if (classNode == null) {
    try {
      classNode = await findClassDeclarationWithHttpResponse(
        codePath: filePath,
      );
      if (classNode != null) {
        foundBy_findClassDeclarationWithHttpResponse = true;
        // printSuccess("found by findClassDeclarationWithHttpResponse");
      }
    } catch (e) {}
  }
  if (classNode == null) {
    throw Exception(
      'ClassType "$innerType" not found in the library, its parts, its direct imports, or the project.',
    );
  }

  // print(classNode);
  String? responseDataType;
  TypeAnnotation? dataTypeNode;

  for (final field in searchFields) {
    final fieldVisitor = FieldVisitor(fieldName: field);
    classNode.accept(fieldVisitor);
    responseDataType = fieldVisitor.dataType;
    dataTypeNode = fieldVisitor.dataTypeNode;
    if (responseDataType != null && dataTypeNode != null) {
      break;
    }
  }

  // print("$innerType");
  if (responseDataType == null || dataTypeNode == null) {
    throw Exception('Field "$searchFields" not found in class "$innerType"');
  }

  String? importUri;
  if (classDeclarationPath != null) {
    importUri = importClauseToPath(classDeclarationPath);
  }

  // printInfo("↓↓↓ result ↓↓↓");
  return {
    "searchFields": searchFields,
    "hitClass": innerType,
    "hitField": foundBy_findClassDeclarationWithHttpResponse ? "body" : "data",
    "responseDataType": responseDataType,
    "importUri": foundBy_findClassDeclarationWithHttpResponse
        ? "import 'package:http/src/response.dart';"
        : importUri,
    "classDeclarationPath": classDeclarationPath,
  };
}

class _MethodVisitor extends RecursiveAstVisitor<void> {
  final String methodName;
  TypeAnnotation? returnType;

  _MethodVisitor(this.methodName);

  @override
  void visitMethodDeclaration(MethodDeclaration method) {
    if (method.name.lexeme == methodName) {
      returnType = method.returnType;
    }
  }
}

String unwrapFuture(String input) {
  // Explanation:
  // ^Future<  : Must start with "Future<"
  // (.*)      : Greedy match - captures everything until the LAST ">"
  // >$        : Must end with ">"
  final regex = RegExp(r"^Future<(.*)>$");
  final match = regex.firstMatch(input.trim());

  if (match != null) {
    // This will now correctly return "List<Pet>?"
    return match.group(1)!;
  }
  return input;
}
