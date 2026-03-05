import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

mixin ParseStringResultMixin {
  ParseStringResult? _parsedFile;

  String get filePath;

  ParseStringResult parsedFile() {
    // 1. The source code (A Freezed Union example)
    if (_parsedFile != null) {
      return _parsedFile!;
    }
    final parsed = parseFile(
      path: filePath,
      featureSet: FeatureSet.latestLanguageVersion(),
    );
    _parsedFile = parsed;
    return _parsedFile!;
  }

  String get parsedFileContent => parsedFile().content;

  CompilationUnit get parsedFileUnit => parsedFile().unit;
}
