import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

class MethodsListVisitor extends RecursiveAstVisitor<void> {
  MethodDeclaration? targetNode;
  final String? className;
  final String? methodName;

  MethodsListVisitor([this.className, this.methodName]);

  List<String> methodList = [];

  String? _currentClassName;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    if (className != null) {
      if (node.namePart.typeName.toString() == className) {
        _currentClassName = className;
        // print("_currentClassname $_currentClassName");
      }
    }
    super.visitClassDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    // Check if the method name matches target
    if (className != null) {
      if (_currentClassName != className) {
        return;
      }
    }
    methodList.add(node.name.lexeme);
    if (node.name.lexeme == methodName) {
      targetNode = node;
    }
    // Continue searching specifically to support nested classes/extensions
    super.visitMethodDeclaration(node);
  }
}
