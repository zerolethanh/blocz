import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

void visitChildren(String codePath, AstVisitor visitor) {
  final parsed = parseFile(
    path: codePath,
    featureSet: FeatureSet.latestLanguageVersion(),
  );
  final unit = parsed.unit;
  unit.visitChildren(visitor);
}
