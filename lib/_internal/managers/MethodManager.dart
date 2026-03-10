import 'package:analyzer/dart/ast/ast.dart';
import 'package:blocz/_internal/colors.dart';
import 'package:blocz/_internal/getInnerType.dart';
import 'package:blocz/_internal/managers/mixins/ParseStringResultMixin.dart';

import '../../getClassName.dart';
import '../projectContext.dart';
import '../visitors/BlocVisitors.dart';
import '../visitors/FieldVisitor.dart';
import '../visitors/MethodVisitors.dart';
import 'data/ManagersResultData.dart';
import 'interfaces/IMethodManager.dart';

class MethodManager with ParseStringResultMixin implements IMethodManager {
  @override
  final String filePath;
  @override
  final String identifier;
  String? methodName;
  String? className;

  MethodManagerResultData get dataSingleton =>
      MethodManagerResultData.singleton;

  MethodManager({required this.filePath, required this.identifier}) : super() {
    final splits = identifier.split(".");
    if (splits.length >= 2) {
      className = splits.first;
      methodName = splits.last;
    } else {
      className = null;
      methodName = splits.last;
    }
    if (className == null || className!.isEmpty) {
      className = getFirstClassNameInFile(filePath);
    }
    assert(className != null);
    // assert(methodName != null);
    dataSingleton.update(
      filePath: filePath,
      identifier: identifier,
      fullIdentifier: '$className.$methodName',
      identifierFormat: IMethodManager.identifierFormat,
      manager: "MethodManager",
    );
  }

  @override
  MethodManagerResultData ON_invocationFindByMethodName({
    String? replacementHandlerBody,
  }) {
    final visitor = ON_invocationFindByMethodNameVisitor(methodName!);
    parsedFileUnit.visitChildren(visitor);
    if (visitor.result == null) {
      return dataSingleton;
    }
    if (replacementHandlerBody == null) {
      dataSingleton.addTaskResultValue(visitor.result);
      return dataSingleton;
    }

    String? fullNewSourceCode;
    fullNewSourceCode = parsedFileContent.replaceRange(
      visitor.result!.handlerBody.offset,
      visitor.result!.handlerBody.end,
      replacementHandlerBody.trim(),
    );
    dataSingleton.addTaskResultValue(visitor.result, {
      "fullNewSourceCode": fullNewSourceCode,
    });
    return dataSingleton;
  }

  @override
  MethodManagerResultData ON_invocationListAllMethods() {
    var visitor = ON_invocationListAllMethodsVisitor();
    parsedFileUnit.visitChildren(visitor);
    if (visitor.result.isNotEmpty) {
      dataSingleton.addTaskResultValue(visitor.result);
    }

    return dataSingleton;
  }

  @override
  MethodManagerResultData ON_invocationLastLineNumber() {
    final visitor = ON_invocationLastLineNumberVisitor();
    parsedFileUnit.visitChildren(visitor);
    if (visitor.lastOnNode != null) {
      dataSingleton.addTaskResultValue(
        parsedFile().lineInfo.getLocation(visitor.lastOnNode!.end).lineNumber,
      );
    }

    return dataSingleton;
  }

  @override
  MethodManagerResultData listAllMethods() {
    final unit = parsedFile().unit;

    // print(unit.languageVersion.hashCode);
    final finder = MethodsListVisitor(className);
    unit.visitChildren(finder);

    final methodlist = finder.methodList;
    dataSingleton.addTaskResultValue(methodlist);
    return dataSingleton;
  }

  @override
  MethodManagerResultData returnType() {
    final visitor = MethodsListVisitor(className, methodName);
    parsedFileUnit.visitChildren(visitor);

    if (visitor.targetNode != null) {
      final returnType = visitor.targetNode!.returnType;
      dataSingleton.addTaskResultValue(returnType?.toSource());
    }
    return dataSingleton;
  }

  @override
  MethodManagerResultData returnInnerType([int innerLevel = 1]) {
    final visitor = MethodsListVisitor(className, methodName);
    parsedFileUnit.visitChildren(visitor);

    if (visitor.targetNode != null) {
      final returnType = visitor.targetNode!.returnType;
      dataSingleton.addTaskResultValue(
        getInnerTypeByLevel(returnType!, level: innerLevel),
      );
    }
    return dataSingleton;
  }

  @override
  MethodManagerResultData returnInnerPropType(
    String propName, [
    int innerLevel = 1,
    // @deprecated String? backOffLibraryUri = "package:http/src/response.dart"
  ]) {
    final visitor = MethodsListVisitor(className, methodName);
    parsedFileUnit.visitChildren(visitor);

    if (visitor.targetNode == null) {
      return dataSingleton;
    }

    final returnType = visitor.targetNode!.returnType;
    // print("returnType $returnType");
    final innerType = getInnerTypeByLevel(
      returnType,
      level: innerLevel,
      useLexeme: true,
    );

    if (innerType == "void") {
      // dataSingleton.addTaskResultValue("void");
      printInfo(
        "[returnInnerPropType] innerType=void, skip returnInnerPropType",
      );
      return dataSingleton;
    }

    if (innerType == null) {
      return dataSingleton;
    }

    final propNames = propName.replaceAll(RegExp(r'\s+'), "").split(",")
      ..removeWhere((val) => val.isEmpty);

    for (final propName in propNames) {
      final result = findProjectWideResponseType(
        innerType: innerType,
        filePath: filePath,
        initialUnit: parsedFileUnit,
        searchFields: [propName],
      );
      // if(result.isExists) {
      dataSingleton.mergeTaskResultValue({
        "props": {
          propName: {
            "type": result.type ?? "dynamic",
            "isExists": result.isExists,
          },
        },
      });
      // }
    }

    return dataSingleton;
  }

  @override
  Future<MethodManagerResultData> returnInnerTypeOfHttpResponse({
    String propName = "body",
    String? libraryUri = "package:http/src/response.dart",
    String? libraryClassName = "Response",
    int innerLevel = 1,
  }) async {
    final visitor = MethodsListVisitor(className, methodName);
    parsedFileUnit.visitChildren(visitor);
    if (visitor.targetNode == null) {
      return dataSingleton;
    }

    final returnType = visitor.targetNode!.returnType;
    // print("returnType $returnType");
    final innerType = getInnerTypeByLevel(
      returnType,
      level: innerLevel,
      useLexeme: true,
    );

    if (innerType == "void") {
      dataSingleton.mergeTaskResultValue({
        "props": {
          propName: {"type": "void"},
        },
      });
      return dataSingleton;
    }
    if (innerType == null) {
      return dataSingleton;
    }
    // print("innerType $innerType");
    if (libraryUri != null) {
      try {
        final classNode = await findClassDeclarationWithHttpResponse(
          codePath: filePath,
          targetLibraryUri: libraryUri,
          targetClassName: libraryClassName,
        );
        // print(classNode);
        String? responseDataType;
        TypeAnnotation? dataTypeNode;

        final fieldVisitor = FieldVisitor(fieldName: propName);
        classNode?.accept(fieldVisitor);
        responseDataType = fieldVisitor.dataType;
        dataTypeNode = fieldVisitor.dataTypeNode;
        if (responseDataType != null && dataTypeNode != null) {
          dataSingleton.mergeTaskResultValue({
            "props": {
              propName: {
                "type": responseDataType,
                "inClass": classNode?.namePart.toString(),
                "libraryUri": libraryUri,
                // "libraryImports":classNode?.declaredFragment?.libraryFragment.libraryImports.toString(),
                // "libraryExports":classNode?.declaredFragment?.libraryFragment.libraryExports.toString(),
                // "importedLibraries":classNode?.declaredFragment?.libraryFragment.importedLibraries.toString(),
                // "partIncludes":classNode?.declaredFragment?.libraryFragment.partIncludes.toString(),
              },
            },
          });
        }
      } catch (e) {
        printWarning("[returnInnerBodyType] $e");
      }
    }

    return dataSingleton;
  }

  @override
  MethodManagerResultData paramsList() {
    final visitor = MethodsListVisitor(className, methodName);
    parsedFileUnit.visitChildren(visitor);

    if (visitor.targetNode != null) {
      final parameters = visitor.targetNode!.parameters;
      // print(parameters);
      if (parameters != null) {
        dataSingleton.mergeTaskResultValue({
          "parameters": parameters.toString(),
          "parameters.parameters": parameters.parameters.toString(),
        });
      }
    }
    return dataSingleton;
  }

  @override
  MethodManagerResultData info() {
    final visitor = MethodsListVisitor(className, methodName);
    parsedFileUnit.visitChildren(visitor);

    if (visitor.targetNode != null) {
      final node = visitor.targetNode!;
      final body = node.body;
      final info = {
        'name': node.name.lexeme,
        'returnType': node.returnType?.toSource(),
        'parameters': node.parameters?.toSource(),
        'isAbstract': node.isAbstract,
        'isAsynchronous': body.isAsynchronous,
        'isGenerator': body.isGenerator,
        'isStatic': node.isStatic,
        // 'isExternal': body.isExternal,
        'body': body.toSource(),
      };
      dataSingleton.addTaskResultValue(info);
    }
    return dataSingleton;
  }
}

class MethodManagerResultData extends ManagersResultData {
  // Private constructor
  MethodManagerResultData._singleton() : super();

  // Singleton instance
  static final MethodManagerResultData singleton =
      MethodManagerResultData._singleton();

  // Factory constructor
  factory MethodManagerResultData() {
    return singleton;
  }

  Map<String, dynamic> toJson() {
    return {
      "manager": singleton.manager,
      "filePath": singleton.filePath,
      "fullIdentifier": singleton.parsedIdentifier,
      "identifierFormat": singleton.identifierFormat,
      "excutedTasks": singleton.succeedTasks,
      ...singleton.otherProps,
    };
  }
}
