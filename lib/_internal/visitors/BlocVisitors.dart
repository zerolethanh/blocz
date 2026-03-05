import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

class OnInvocationNodes {
  final TypeAnnotation event;
  final FunctionBody handlerBody;

  OnInvocationNodes(this.event, this.handlerBody);

  Map<String, dynamic> toJson() {
    return {
      'event': event.toSource(),
      'handlerBody': handlerBody.toSource(),
    };
  }
}

class BlocOnMethodFoundElement {
  final String foundNode;
  final String eventType;
  final String? handlerSource;
  final String? handlerSourceNode;
  final String? handlerParameters;
  final String? handlerBody;
  final bool isAsync;
  final bool isGenerator;
  final String? handlerReturnType;

  BlocOnMethodFoundElement({
    required this.foundNode,
    required this.eventType,
    this.handlerSource,
    this.handlerSourceNode,
    this.handlerParameters,
    this.handlerBody,
    this.isAsync = false,
    this.isGenerator = false,
    this.handlerReturnType,
  });

  Map<String, dynamic> toJson() {
    return {
      'foundNode': foundNode,
      'eventType': eventType,
      'handlerSource': handlerSource,
      'handlerSourceNode': handlerSourceNode,
      'handlerParameters': handlerParameters,
      'handlerBody': handlerBody,
      'isAsync': isAsync,
      'isGenerator': isGenerator,
      'handlerReturnType': handlerReturnType,
    };
  }
}

BlocOnMethodFoundElement? _extractBlocOnMethodElement(MethodInvocation node) {
  if (node.methodName.name == 'on' &&
      node.typeArguments != null &&
      node.typeArguments!.arguments.isNotEmpty) {
    final enclosingClass = node.thisOrAncestorOfType<ClassDeclaration>();

    String foundNode = node.toSource();
    String eventType = node.typeArguments!.arguments.first.toSource();

    String? handlerSource;
    String? handlerSourceNode;
    String? handlerParameters;
    String? handlerBody;
    bool isAsync = false;
    bool isGenerator = false;
    String? handlerReturnType;

    if (node.argumentList.arguments.isNotEmpty) {
      final argument = node.argumentList.arguments.first;
      handlerSource = argument.toSource();
      handlerSourceNode = argument.toSource();

      if (argument is FunctionExpression) {
        final parameters = argument.parameters;
        handlerParameters = parameters?.toSource();
        handlerReturnType = 'FutureOr<void>';

        final body = argument.body;
        isAsync = body.isAsynchronous;
        isGenerator = body.isGenerator;

        final bodySource = body.toSource();
        if (bodySource.startsWith('{') && bodySource.endsWith('}')) {
          handlerBody = bodySource.substring(1, bodySource.length - 1).trim();
        } else {
          handlerBody = bodySource;
        }
      } else if (argument is SimpleIdentifier) {
        final methodName = argument.name;

        if (enclosingClass != null) {
          for (final member in enclosingClass.members) {
            if (member is MethodDeclaration && member.name.lexeme == methodName) {
              final parameters = member.parameters;
              handlerParameters = parameters?.toSource();
              handlerReturnType = member.returnType?.toSource();

              final body = member.body;
              isAsync = body.isAsynchronous;
              isGenerator = body.isGenerator;

              final bodySource = body.toSource();
              if (bodySource.startsWith('{') && bodySource.endsWith('}')) {
                handlerBody =
                    bodySource.substring(1, bodySource.length - 1).trim();
              } else {
                handlerBody = bodySource;
              }
              break;
            }
          }
        }
      }
    }

    return BlocOnMethodFoundElement(
      foundNode: foundNode,
      eventType: eventType,
      handlerSource: handlerSource,
      handlerSourceNode: handlerSourceNode,
      handlerParameters: handlerParameters,
      handlerBody: handlerBody,
      isAsync: isAsync,
      isGenerator: isGenerator,
      handlerReturnType: handlerReturnType,
    );
  }
  return null;
}

class ON_invocationListAllMethodsVisitor extends GeneralizingAstVisitor<void> {
  List<BlocOnMethodFoundElement> result = [];

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final element = _extractBlocOnMethodElement(node);
    if (element != null) {
      result.add(element);
    }
    super.visitMethodInvocation(node);
  }
}

class BlocOnMethodFindByEventTypeVisitor extends GeneralizingAstVisitor<void> {
  final String eventTypeToFind;
  BlocOnMethodFoundElement? result;

  BlocOnMethodFindByEventTypeVisitor(this.eventTypeToFind);

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (result != null) {
      return;
    }

    final element = _extractBlocOnMethodElement(node);
    if (element != null && element.eventType == eventTypeToFind) {
      result = element;
    }

    if (result == null) {
      super.visitMethodInvocation(node);
    }
  }
}

class ON_invocationFindByMethodNameVisitor
    extends GeneralizingAstVisitor<void> {
  final String methodName;
  OnInvocationNodes? result;

  ON_invocationFindByMethodNameVisitor(this.methodName);

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (result != null) {
      return;
    }

    if (node.methodName.name == 'on' &&
        node.argumentList.arguments.isNotEmpty) {
      final argument = node.argumentList.arguments.first;

      if (argument is SimpleIdentifier && argument.name == methodName) {
        TypeAnnotation? eventNode;
        if (node.typeArguments != null &&
            node.typeArguments!.arguments.isNotEmpty) {
          eventNode = node.typeArguments!.arguments.first;
        }

        FunctionBody? handlerBodyNode;
        final enclosingClass = node.thisOrAncestorOfType<ClassDeclaration>();
        if (enclosingClass != null) {
          for (final member in enclosingClass.members) {
            if (member is MethodDeclaration &&
                member.name.lexeme == methodName) {
              handlerBodyNode = member.body;
              break;
            }
          }
        }

        if (eventNode != null && handlerBodyNode != null) {
          result = OnInvocationNodes(eventNode, handlerBodyNode);
        }
      }
    }

    if (result == null) {
      super.visitMethodInvocation(node);
    }
  }
}

class ON_invocationLastLineNumberVisitor extends RecursiveAstVisitor<void> {
  MethodInvocation? lastOnNode;

  int lineNumber = 0;
  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.methodName.name == 'on') {
      // Keep updating lastOnNode if we find an 'on' call with a higher offset
      if (lastOnNode == null || node.offset > lastOnNode!.offset) {
        lastOnNode = node;
        // 5. Calculate line number from the 'end' offset
        // return parseResult.lineInfo.getLocation(lastOnNode!.end).lineNumber;
      }
    }
    super.visitMethodInvocation(node);
  }
}
