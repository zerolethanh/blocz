import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/file_system/physical_file_system.dart';

import '_internal/getSdkPath.dart';
import '_internal/typedef.dart';
import 'get_project_root_path.dart';

JSONString? importClauseToPath(String codePath) {
  final projectRootPath = getProjectRootPath(scriptPath: codePath);
  if (projectRootPath == null) {
    // print("-- getImportClause: Could not determine project root for $codePath");
    return null;
  }

  final sdkPath = getSdkPath();
  if (sdkPath == null) {
    print(
      "-- getImportClause: ERROR: Could not find a valid Dart SDK."
      "-- getImportClause: Please ensure FLUTTER_ROOT is set or the script is run with a Dart executable from an SDK.",
    );

    return null;
  }
  // print("-- getImportClause: Using SDK path: $sdkPath");

  final collection = AnalysisContextCollection(
    includedPaths: [projectRootPath],
    resourceProvider: PhysicalResourceProvider.INSTANCE,
    sdkPath: sdkPath,
  );

  final context = collection.contextFor(codePath);
  final uri = context.currentSession.uriConverter.pathToUri(codePath);

  final uriString = uri?.toString();
  if (uriString == null) {
    print("-- getImportClause: Could not determine package URI for $codePath");
    return null;
  }

  final result = "import '$uriString';";
  // print("-- getImportClause result: ");
  // print(result);
  return result;
}
