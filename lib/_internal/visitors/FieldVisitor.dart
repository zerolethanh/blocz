
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';

class FieldVisitor extends RecursiveAstVisitor<void> {
  String? dataType;
  TypeAnnotation? dataTypeNode;
  bool isExists = false;

  final String fieldName;

  FieldVisitor({required this.fieldName});

  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    if (dataType != null) return;

    print("$fieldName $dataType: ${node.isStatic} ${node.fields.isConst}");
    if (node.isStatic && node.fields.isConst) {
      print("static const variables ${node.fields.variables}");
      for (var variable in node.fields.variables) {
        if (variable.name.lexeme != fieldName) {
          continue;
        }

        // print("${variable.name.lexeme} ${fieldName}");
        print(variable.toString());
        var element = variable.declaredFragment;
        print("element $element");


        if (element != null) {
          // 4. Get the Type
          DartType type = element.element.type;

          print(type); // Output: Set<String>
          print(type.isDartCoreSet); // Output: true
          // dataTypeNode = type;
          dataType = type.toString();
          isExists = true;
          print("${dataType}");
          return;
        } else {
          // 1. Check if there is an initializer
          var initializer = variable.initializer;

          // 2. Check if it is a Set/Map literal
          if (initializer is SetOrMapLiteral) {
            final result = getLiteralTypeInfo(initializer);
            dataType = result.dataType;
            dataTypeNode = result.dataTypeNode;
            isExists = result.isExists;
            if (isExists) {
              return;
            }
          }
        }
      }
    }

    for (final variable in node.fields.variables) {
      if (variable.name.lexeme == fieldName) {
        dataTypeNode = node.fields.type;
        dataType = dataTypeNode?.toSource();
        isExists = true;
        break;
      }
    }
    super.visitFieldDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    if (dataType != null) return;
    // search for `body` getter field
    // eg: String get body => _encodingForHeaders(headers).decode(bodyBytes);
    if (node.isGetter && node.name.lexeme == fieldName) {
      dataTypeNode = node.returnType;
      // print("dataTypeNode $dataTypeNode");
      dataType = dataTypeNode?.toSource();
      isExists = true;
    }
  }
}


/// Returns a tuple containing:
/// 1. [dataType]: The full string representation (e.g., "Set<String>")
/// 2. [dataTypeNode]: The AST node for the inner type (e.g., the 'String' node).
///    - For Sets <T>, this is T.
///    - For Maps <K, V>, this is V (the value type), or null if strictly ambiguous.
/// 3. [isExists]: A boolean indicating if the type information could be determined.
({String? dataType, TypeAnnotation? dataTypeNode, bool isExists}) getLiteralTypeInfo(
    SetOrMapLiteral literal) {
  var typeArgs = literal.typeArguments;

  // 1. Explicit Type Arguments exist (e.g. <String>{...})
  if (typeArgs != null) {
    var args = typeArgs.arguments;

    if (args.length == 1) {
      // Case: Set<T>
      // We return the single TypeAnnotation 'T'
      return (
      dataType: 'Set<${args[0]}>',
      dataTypeNode: args[0],
      isExists: true
      );
    } else if (args.length == 2) {
      // Case: Map<K, V>
      // Ambiguous which node to return, but usually 'V' is the "data" type.
      // We return the String representation, and the Value node for utility.
      return (
      dataType: 'Map<${args[0]}, ${args[1]}>',
      dataTypeNode: args[1], // Returning 'V' by convention, or change to null
      isExists: true
      );
    }
  }

  // 2. Implicit / Inferred Types (e.g. {'a'})
  // We cannot return a TypeAnnotation node because one does not exist in the source code.
  else {
    if (literal.elements.isEmpty || literal.elements.first is MapLiteralEntry) {
      return (dataType: 'Map<dynamic, dynamic>', dataTypeNode: null, isExists: true);
    } else {
      return (dataType: 'Set<dynamic>', dataTypeNode: null, isExists: true);
    }
  }

  return (dataType: null, dataTypeNode: null, isExists: false);
}