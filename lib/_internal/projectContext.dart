import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:blocz/_internal/colors.dart';

import '../get_project_root_path.dart';
import 'getSdkPath.dart';

AnalysisContextCollection? getCollection(String codePath) {
  final projectRootPath = getProjectRootPath(scriptPath: codePath);
  if (projectRootPath == null) {
    return null;
  }

  final sdkPath = getSdkPath();
  if (sdkPath == null) {
    print(
      "-- ERROR: Could not find a valid Dart SDK."
      "-- Please ensure FLUTTER_ROOT is set or the script is run with a Dart executable from an SDK.",
    );
    return null;
  }

  final collection = AnalysisContextCollection(
    includedPaths: [projectRootPath],
    resourceProvider: PhysicalResourceProvider.INSTANCE,
    sdkPath: sdkPath,
  );
  return collection;
}

AnalysisContext? getProjectContext(String codePath) {
  final collection = getCollection(codePath);
  return collection?.contextFor(codePath);
}

List<AnalysisContext>? getProjectContextList(String codePath) {
  final collection = getCollection(codePath);
  return collection?.contexts;
}

Future<ClassElement?> findClassElementWithLibraryUriAndClassName({
  required String codePath,
  required String targetLibraryUri,
  required String targetClassName,
}) async {
  final contexts = getProjectContextList(codePath);
  if (contexts == null || contexts.isEmpty) {
    printError("no project contexts found");
    exit(0);
  }
  // targetLibraryUri ??= 'package:http/http.dart';
  // targetClassName ??= 'Response';
  final lib = await contexts.first.currentSession.getLibraryByUri(
    targetLibraryUri,
  );

  if (lib is LibraryElementResult) {
    final targetElement = lib.element.exportNamespace.get2(targetClassName);
    if (targetElement is ClassElement) {
      return targetElement;
    }
    return null;
  }
  return null;
}

Future<ClassDeclaration?> findClassDeclarationWithHttpResponse({
  required String codePath,
  String? targetLibraryUri,
  String? targetClassName,
}) async {
  final context = getProjectContext(codePath);
  if (context == null) {
    printError("no project context found");
    return null;
  }

  targetLibraryUri ??= 'package:http/src/response.dart';
  targetClassName ??= 'Response';

  final uriResult = context.currentSession.uriConverter.uriToPath(
    Uri.parse(targetLibraryUri),
  );
  if (uriResult == null) {
    printError('Could not find path for library "$targetLibraryUri"');
    return null;
  }
  final libraryPath = uriResult;

  final result = await context.currentSession.getResolvedUnit(libraryPath);

  if (result is ResolvedUnitResult) {
    for (final declaration in result.unit.declarations) {
      // print(declaration is ClassDeclaration);
      if (declaration is ClassDeclaration &&
          declaration.namePart.toSource() == targetClassName) {
        return declaration;
      }
    }
  }

  return null;
}
