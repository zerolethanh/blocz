import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/element/element.dart';

import '../projectContext.dart';

Future<ClassElement?> resolveSymbol(
  String symbolName,
  String filePath, [
  String? libraryUri = "package:http/http.dart",
]) async {
  final result = await resolveFile(path: filePath);
  if (result is! ResolvedUnitResult) {
    return null;
  }
  if (libraryUri != null) {
    final contexts = getProjectContextList(filePath);
    final lib = await contexts?.first.currentSession.getLibraryByUri(
      libraryUri,
    );
    if (lib is LibraryElementResult) {
      final targetElement = lib.element.exportNamespace.get2(symbolName);
      if (targetElement is ClassElement) {
        return targetElement;
      }
    }
  }

  final libraryElement = result.libraryElement;
  final exportNamespace = libraryElement.exportNamespace;
  final element = exportNamespace.get2(symbolName);

  print("[resolveSymbol] element $element");
  if (element?.name != null && element is ClassElement) {
    return element;
  }

  return null;
}
