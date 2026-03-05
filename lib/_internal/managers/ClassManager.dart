import 'package:blocz/_internal/managers/ConstructorManager.dart';
import 'package:blocz/_internal/managers/MethodManager.dart';
import 'package:blocz/_internal/managers/mixins/ParseStringResultMixin.dart';

import '../../getClassName.dart';
import '../visitors/ClassVisitors.dart';
import 'data/ManagersResultData.dart';
import 'interfaces/IClassManager.dart';

void main() {
  ClassManager(
    filePath:
    "/Users/lethanh/StudioProjects/ddd/lib/features/order/presentation/bloc/order_event.dart",
    identifier: "",
  )
    ..lastLineNumberGet()
    ..lastConstFactoryLineNumber()
    ..listAllMethods()
    ..listAllConstructors()
    ..listAllGetters().expose();
}

class ClassManager with ParseStringResultMixin implements IClassManager {
  @override
  final String filePath;
  @override
  final String identifier;

  @override
  late String? className;

  @override
  ClassManagerResultData get dataSingleton => ClassManagerResultData.singleton;

  ClassManager({required this.filePath, required this.identifier}) : super() {
    final splits = identifier.split(".");
    if (splits.length >= 2) {
      className = splits.first;
    } else {
      className = null;
    }
    if (className == null || className!.isEmpty) {
      className = getFirstClassNameInFile(filePath);
    }
    assert(className != null);
    dataSingleton.update(
      manager: "ClassManager",
      filePath: filePath,
      identifier: identifier,
      fullIdentifier: '$className',
      identifierFormat: IClassManager.identifierFormat,
    );
  }

  @override
  ClassManagerResultData lastLineNumberGet() {
    final visitor = ClassLastLineVisitor();
    parsedFileUnit.visitChildren(visitor);

    // 4. Check results
    if (visitor.result != null) {
      // 5. Calculate line number from the 'end' offset of the closing brace
      final classNode = visitor.result!;
      final lineNumber = parsedFile().lineInfo
          .getLocation(classNode.body.end)
          .lineNumber;
      dataSingleton.addTaskResultValue(lineNumber);
      return dataSingleton;
    }
    return dataSingleton;
  }

  @override
  ClassManagerResultData lastConstFactoryLineNumber() {
    final visitor = LastConstFactoryVisitor();
    parsedFile().unit.visitChildren(visitor);
    // 4. Check results

    if (visitor.result != null) {
      // 5. Calculate line number from the 'end' offset of the closing brace
      final classNode = visitor.result!;
      final lineNumber = parsedFile().lineInfo
          .getLocation(classNode.body.end)
          .lineNumber;
      dataSingleton.addTaskResultValue(lineNumber);
    }
    return dataSingleton;
  }

  @override
  ClassManagerResultData listAllMethods() {
    final methodList = MethodManager(
      filePath: filePath,
      identifier: identifier,
    ).listAllMethods().toJson();
    // print(methodList);

    dataSingleton.addTaskResultValue(
        methodList["listAllMethods$taskResultSuffix"]);
    return dataSingleton;
  }

  @override
  ClassManagerResultData listAllConstructors() {
    final constructorList = ConstructorManager(
      filePath: filePath,
      identifier: identifier,
    ).listAllConstructorsIgnoreIdentifier().toJson();
    // print(constructorList);
    dataSingleton.addTaskResultValue(
      constructorList["listAllConstructors$taskResultSuffix"],
    );
    return dataSingleton;
  }

  @override
  ClassManagerResultData listAllGetters() {
    final visitor = GettersAndSettersVisitor(className);
    parsedFileUnit.visitChildren(visitor);
    dataSingleton.addTaskResultValue(visitor.getters);
    return dataSingleton;
  }

  @override
  ClassManagerResultData listAllSetters() {
    final visitor = GettersAndSettersVisitor(className);
    parsedFileUnit.visitChildren(visitor);
    dataSingleton.addTaskResultValue(visitor.setters);
    return dataSingleton;
  }
}

class ClassManagerResultData extends ManagersResultData {
  // Private constructor
  ClassManagerResultData._singleton() : super();

  // Singleton instance
  static final ClassManagerResultData singleton =
  ClassManagerResultData._singleton();

  // Factory constructor
  factory ClassManagerResultData() {
    return singleton;
  }
}
