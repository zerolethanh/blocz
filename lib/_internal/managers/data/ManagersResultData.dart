import 'package:blocz/_internal/typedef.dart';

import '../../colors.dart';

const taskResultSuffix = "_result";

class ManagersResultData with JSONStringMixin {
  String? identifier;
  String? parsedIdentifier;
  String? identifierFormat;
  String? filePath;

  String? manager;
  Set<String> succeedTasks = {};
  Map<String, dynamic> otherProps = {};

  ManagersResultData({
    this.identifier,
    this.parsedIdentifier,
    this.identifierFormat,
    this.filePath,
    this.manager,
  });

  void addTaskResultValue(dynamic value, [Map<String, dynamic>? others]) {
    final currentTaskKey = "${addTaskResultValueTaskName()}$taskResultSuffix";
    // print("currentTaskKey $currentTaskKey");
    otherProps[currentTaskKey] = value ?? otherProps[currentTaskKey];
    if (others != null) {
      mergeMaps(otherProps, {currentTaskKey: others});
    }
  }

  void mergeTaskResultValue(Map<String, dynamic>? others) {
    return addTaskResultValue(null, others);
  }

  Map<String, dynamic> mergeMaps(
    Map<String, dynamic> original,
    Map<String, dynamic> newData,
  ) {
    newData.forEach((key, value) {
      if (original.containsKey(key) && original[key] is Map && value is Map) {
        mergeMaps(
          original[key] as Map<String, dynamic>,
          value as Map<String, dynamic>,
        );
      } else {
        original[key] = value;
      }
    });
    return original;
  }

  void update({
    String? identifier,
    String? fullIdentifier,
    String? identifierFormat,
    String? filePath,
    String? manager,
  }) {
    this.identifier = identifier ?? this.identifier;
    this.parsedIdentifier = fullIdentifier ?? this.parsedIdentifier;
    this.identifierFormat = identifierFormat ?? this.identifierFormat;
    this.filePath = filePath ?? this.filePath;
    this.manager = manager ?? this.manager;
  }

  String fullTaskNameAtFrame([List<String>? subTasks]) {
    subTasks?.removeWhere((val) => val.isEmpty);
    String currentTaskMethodName = "";

    // Capture the stack trace
    final stackString = StackTrace.current.toString();
    final frames = StackTrace.current.toString().split('\n');
    final mainLine = getLineNumberOfMain(stackString);
    if (mainLine == null) {
      throw Exception("main line not found");
    }
    final currentTaskLine = frames[mainLine - 1];
    final currentTaskInfo = getClassAndMethodName(currentTaskLine);
    currentTaskMethodName = currentTaskInfo!.split(".").last;
    printWarning("-- adding task: $currentTaskInfo");
    final taskFullName =
        currentTaskMethodName +
        ((subTasks == null || subTasks.isEmpty)
            ? ""
            : ".${subTasks.join(".")}");
    succeedTasks.add(taskFullName);
    return taskFullName;
  }

  int? getLineNumberOfMain(String input) {
    // printInfo(input);
    // Regex Explanation:
    // #\d+       -> Matches the frame number (e.g., #5)
    // \s+        -> Matches one or more spaces
    // main       -> Matches the function name "main"
    // \s*\(      -> Matches optional space and the opening parenthesis
    // .*?        -> Non-greedy match for the file path (up to the colon)
    // :(\d+)     -> Matches the colon and CAPTURES the digits (the line number)
    // :\d+       -> Matches the colon and column number (which we ignore)
    final regExp = RegExp(r'#(\d+)\s+main\s+\(');

    final match = regExp.firstMatch(input);

    if (match != null) {
      // group(1) contains the captured digits from :(\d+)
      // return match.start;
      return int.parse(match.group(1)!);
    }
    return null;
  }

  String? getClassAndMethodName(String input) {
    // Regex Explanation:
    // #\d+\s+           -> Matches "#3" followed by whitespace
    // ([^\s]+)          -> CAPTURE Group 1: Matches everything that is NOT a space (Class.Method)
    // \s+\(             -> Matches the space before the opening parenthesis (stop capturing here)
    final regExp = RegExp(r'#\d+\s+([^\s]+)\s+\(');

    final match = regExp.firstMatch(input);

    if (match != null) {
      return match.group(1);
    }
    return null;
  }

  String addTaskResultValueTaskName([List<String>? subTasks]) {
    return fullTaskNameAtFrame(subTasks);
  }

  JSONString toJSON() {
    return JSONStringResult(
      data: {
        "manager": manager,
        "filePath": filePath,
        "parsedIdentifier": parsedIdentifier,
        "identifierFormat": identifierFormat,
        "succeedTasks": succeedTasks.toList(),
        ...otherProps,
      },
    ).toString();
  }

  @override
  JSONString toString({LogMethods? method = .removeEmptyThenPrettyPrint}) {
    return //"$resultIdentifier\n"
    switch (method) {
      .removeEmpty => removeEmpty(toJSON()),
      .prettyPrint => prettyPrint(toJSON()),
      .removeEmptyThenPrettyPrint => prettyPrint(removeEmpty(toJSON())),
      _ => toJSON(),
    };
  }

  void expose({LogMethods? method = .removeEmptyThenPrettyPrint}) {
    return print(toString(method: method));
  }
}
