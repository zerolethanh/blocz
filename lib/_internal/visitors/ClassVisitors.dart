import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

class ClassFieldVisitor extends RecursiveAstVisitor<void> {
  final String className;
  final String fieldName;
  TypeAnnotation? fieldType;

  ClassFieldVisitor(this.className, this.fieldName);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    if (node.namePart.toString() == className) {
      super.visitClassDeclaration(node);
    }
  }

  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    for (var variable in node.fields.variables) {
      if (variable.name.lexeme == fieldName) {
        fieldType = node.fields.type;
        break;
      }
    }
    super.visitFieldDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    if (node.isGetter && node.name.lexeme == fieldName) {
      fieldType = node.returnType;
    }
    super.visitMethodDeclaration(node);
  }
}

class GettersAndSettersVisitor extends RecursiveAstVisitor<void> {
  final String? className;
  String _currentClassName = "";

  final List<String> getters = [];
  final List<String> setters = [];

  GettersAndSettersVisitor([this.className]);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    _currentClassName = node.namePart.typeName.toString();
    if (className == null || className == _currentClassName) {
      super.visitClassDeclaration(node);
    }
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    if (className != null && _currentClassName != className) {
      return;
    }

    if (node.isGetter) {
      getters.add(node.name.lexeme);
    } else if (node.isSetter) {
      setters.add(node.name.lexeme);
    }
    super.visitMethodDeclaration(node);
  }
}

class ConstructorVisitor extends GeneralizingAstVisitor<void> {
  final String? className;
  final String? constructorName;

  ConstructorVisitor([this.className, this.constructorName]);

  ConstructorDeclaration? targetNode;
  Set<String> constructorList = {};
  String _currentClassName = "";

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    // print("classname: $className - ${node.namePart.toString()}");
    _currentClassName = node.namePart.typeName.toString();
    // _currentClassName = node.namePart.typeName.toString();
    super.visitClassDeclaration(node);
  }

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    if (className != null && _currentClassName != className) {
      return;
    }
    final constructorNameToken = node.name;
    bool isUnamedConstructor = constructorNameToken == null;
    // print({
    //   "className": className,
    //   // "_currentClassName": _currentClassName,
    //   "constructorName": constructorName,
    //   "node.name?.lexeme": constructorNameToken?.lexeme,
    //   "isUnamedConstructor": isUnamedConstructor,
    // });
    // for constructorList
    if (isUnamedConstructor) {
      constructorList.add(_currentClassName);
    } else {
      constructorList.add('$_currentClassName.$constructorNameToken');
    }

    // for targetNode
    if (className == constructorNameToken?.lexeme && isUnamedConstructor) {
      targetNode = node;
    } else if (constructorName == constructorNameToken?.lexeme) {
      targetNode = node;
    }
  }
}

class LastConstFactoryVisitor extends RecursiveAstVisitor<void> {
  ConstructorDeclaration? result;

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    if (node.constKeyword != null &&
        node.factoryKeyword != null) {
      if (result == null || node.offset > result!.offset) {
        result = node;
      }
    }
    super.visitConstructorDeclaration(node);
  }
}

class ClassLastLineVisitor extends RecursiveAstVisitor<void> {
  ClassDeclaration? result;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    // Keep updating lastClassNode if we find a class with a higher offset
    if (result == null || node.offset > result!.offset) {
      result = node;
    }
    super.visitClassDeclaration(node);
  }
}
