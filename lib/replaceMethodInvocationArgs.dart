import 'dart:io';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

/// Surgically replaces the argument list of the first invocation of [methodName] in [filePath].
/// Returns the new file content if found and replaced, or null otherwise.
String? replaceMethodInvocationArgs(
  String filePath,
  String methodName,
  String newArgsSource,
) {
  final file = File(filePath);
  if (!file.existsSync()) return null;

  final content = file.readAsStringSync();
  final result = parseString(
    content: content,
    featureSet: FeatureSet.latestLanguageVersion(),
    throwIfDiagnostics: false,
  );

  final unit = result.unit;
  final visitor = _MethodInvocationReplacementVisitor(methodName);
  unit.accept(visitor);

  if (visitor.targetNode == null) return null;

  final node = visitor.targetNode!;
  return content.replaceRange(
    node.argumentList.offset,
    node.argumentList.end,
    newArgsSource,
  );
}

class _MethodInvocationReplacementVisitor extends RecursiveAstVisitor<void> {
  final String methodName;
  MethodInvocation? targetNode;

  _MethodInvocationReplacementVisitor(this.methodName);

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (targetNode != null) return;

    if (node.methodName.name == methodName) {
      targetNode = node;
    }
    super.visitMethodInvocation(node);
  }
}
