import 'package:blocz/_internal/managers/mixins/ParseStringResultMixin.dart';
import 'package:blocz/getClassName.dart';

import '../visitors/ClassVisitors.dart';
import 'data/ManagersResultData.dart';
import 'interfaces/IConstructorManager.dart';

class ConstructorManager
    with ParseStringResultMixin
    implements IConstructorManager {
  @override
  final String filePath;
  @override
  final String identifier;

  String fullIdentifier = "";
  String? constructorName;
  String? className;

  ConstructorManagerResultData get dataSingleton =>
      ConstructorManagerResultData.singleton;

  ConstructorManager({required this.filePath, required this.identifier})
    : super() {
    final splits = identifier.replaceAll(RegExp(r'\s+'), "").split(".");
    if (splits.length >= 2) {
      className = splits.first;
      constructorName = splits.last;
    } else {
      className = null;
      constructorName = splits.last;
    }
    if (className == null || className!.isEmpty) {
      className = getFirstClassNameInFile(filePath);
    }
    assert(className != null);
    // fullIdentifier = '$className.$constructorName';

    dataSingleton.update(
      manager: "ConstructorManager",
      filePath: filePath,
      identifier: identifier,
      fullIdentifier: '$className.$constructorName',
      identifierFormat: IConstructorManager.identifierFormat,
    );
    // assert(constructorName != null);
  }

  @override
  ConstructorManagerResultData findOrReplace({String? replacementText}) {
    final finder = ConstructorVisitor(className, constructorName!);
    parsedFileUnit.visitChildren(finder);

    // final task = dataSingleton.currentFnAsTask();

    if (finder.targetNode != null) {
      final node = finder.targetNode!;
      final offset = node.offset;
      final end = node.end;

      // 4. Define the replacement
      // Perhaps we want to rename the event or add a parameter
      if (replacementText != null) {
        // 5. Replace
        final newSource = parsedFileContent.replaceRange(
          node.offset,
          node.end,
          replacementText.trim(),
        );

        dataSingleton.addTaskResultValue({
          "foundNode": node.toSource(),
          "foundOffset": offset,
          "foundEnd": end,
          "newSourceCode": newSource,
        });
        return dataSingleton;
      }

      dataSingleton.addTaskResultValue({
        "foundNode": node.toSource(),
        "foundOffset": offset,
        "foundEnd": end,
      });
      return dataSingleton;
    }
    // node not found
    // printWarning('[findOrReplace] constructor "$fullIdentifier" not found.');
    // dataInstance.update(foundNode: null, foundOffset: 0, foundEnd: 0);
    dataSingleton.addTaskResultValue({
      "foundNode": null,
      "foundOffset": 0,
      "foundEnd": 0,
    });
    return dataSingleton;
  }

  @override
  ConstructorManagerResultData listAllConstructors() {
    /// 3. Find the specific Constructor
    final finder = ConstructorVisitor(className);
    parsedFileUnit.visitChildren(finder);
    dataSingleton.addTaskResultValue(finder.constructorList.toList());
    return dataSingleton;
  }

  @override
  ConstructorManagerResultData listAllConstructorsIgnoreIdentifier() {
    final unit = parsedFile().unit;

    /// 3. Find the specific Constructor
    final finder = ConstructorVisitor();
    unit.visitChildren(finder);
    // result.update(constructorList: finder.constructorList.toList());
    dataSingleton.addTaskResultValue(finder.constructorList.toList());
    return dataSingleton;
  }

  @override
  bool hasFactoryConstructor() {
    // Use the visitor to crawl the file
    final finder = ConstructorVisitor(className);
    parsedFileUnit.visitChildren(finder);

    var constList = finder.constructorList;

    // Ensure the target we are looking for is formatted exactly like the list items
    String target;
    if (constructorName == null || constructorName!.isEmpty) {
      target = className!;
    } else {
      target = "$className.$constructorName";
    }
    return constList.contains(target);
  }
}

// Class Visitor giúp đi qua từng node trong cây AST
class ConstructorManagerResultData extends ManagersResultData {
  // Private constructor
  ConstructorManagerResultData._singleton() : super();

  // Singleton dataInstance
  static final ConstructorManagerResultData singleton =
      ConstructorManagerResultData._singleton();

  // Factory constructor
  factory ConstructorManagerResultData() {
    return singleton;
  }

  Map<String, dynamic> toJson() {
    return {
      "manager": manager,
      "filePath": filePath,
      "fullIdentifier": parsedIdentifier,
      "identifierFormat": identifierFormat,
      "succeedTasks": succeedTasks.toList(),
      ...singleton.otherProps,
    };
  }
}
