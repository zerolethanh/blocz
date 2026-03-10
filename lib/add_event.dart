import 'dart:convert';
import 'dart:io';

import 'package:blocz/_internal/colors.dart';
import 'package:blocz/_internal/managers/ConstructorManager.dart';
import 'package:blocz/_internal/managers/MethodManager.dart';
import 'package:blocz/extractConstructorParams.dart';
import 'package:blocz/extractMethodListFromClass.dart';
import 'package:blocz/extractMethodParams.dart';
import 'package:blocz/extractMethodResponseTypeWithDataField.dart';
import 'package:blocz/extractMethodResponseTypeWithField.dart';
import 'package:blocz/findClassNameByMethodName.dart';
import 'package:blocz/findLastClassbodyLineNumber.dart';
import 'package:blocz/findLastConstFactory.dart';
import 'package:blocz/findLast_On_LineNumber.dart';
import 'package:blocz/getClassName.dart';
import 'package:blocz/makeUtils.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

/// Adds one or more events to a BLoC.
///
/// If [apiPath] is provided and [event] is null or empty, it extracts all public methods
/// from the specified API class and generates an event for each.
/// Otherwise, it generates a single event specified by [event].
Future<void> addEvent(
  String domain,
  String? name,
  String? event,
  String? apiPath,
  String? method, {
  String? writeDir,
  bool update = false,
}) async {
  // multiple event generate
  if (apiPath != null && (event == null || event.trim().isEmpty)) {
    final methods = extractMethodListFromClass(apiPath);
    if (methods.isNotEmpty) {
      print(
        'Found ${methods.length} methods in $apiPath. Generating events...',
      );
      List<dynamic> results = [];
      for (final methodName in methods) {
        if (methodName.endsWith("WithHttpInfo")) {
          // skip ...WithHttpInfo openapi generated method
          continue;
        }
        if (method != null &&
            method.trim().isNotEmpty &&
            methodName != method) {
          // skip method that is not the one specified
          continue;
        }
        results.add(
          await _addSingleEvent(
            domain,
            name,
            methodName,
            apiPath,
            methodName,
            writeDir: writeDir,
            update: update,
          ),
        );
      }

      sleep(const Duration(milliseconds: 100));
      if (results.isNotEmpty) {
        String dir = "";
        for (final result in results) {
          dir = result.$1;
          if (dir.isNotEmpty) {
            break;
          }
        }
        if (dir.isEmpty) {
          printWarning("No events generated.");
          return;
        }
        runBuildRunner(dir);
        runDartFormat(dir);
      }
      printSuccess(' ✅ Finished generating events from $apiPath.');
    } else {
      printWarning(
        'No public methods found in $apiPath to generate events from.',
      );
    }
    return;
  }

  if (event == null || event.trim().isEmpty) {
    printError(' ❗️ Event name is required (or apiPath must be provided).');
    return;
  }

  // single event generate
  final result = await _addSingleEvent(
    domain,
    name,
    event,
    apiPath,
    method ?? event,
    writeDir: writeDir,
    update: update,
  );
  if (result.$1.isEmpty) {
    printWarning("No events generated.");
    return;
  }
  runBuildRunner(result.$1);
  runDartFormat(result.$1);
  if (apiPath != null && apiPath.trim().isNotEmpty) {
    printSuccess(' ✅ Finished generating events from $apiPath.');
  } else {
    printSuccess(' ✅ Finished generating events.');
  }
}

/// Generates a single event, including its corresponding event and state classes,
/// and updates the BLoC to handle the event.
///
/// Returns a record containing the directory where the files were written and the paths to the
/// generated BLoC, event, and state files.
Future<(String, String, String, String)> _addSingleEvent(
  String domain,
  String? name,
  String event,
  String? apiPath,
  String? method, {
  String? writeDir,
  bool update = false,
}) async {
  final bool isEmptyName = name == null || name.trim().isEmpty;
  name = isEmptyName ? domain : name;

  final String nameSnake = name.snakeCase;
  final String domainSnake = domain.snakeCase;
  final String commonFileName = isEmptyName
      ? nameSnake
      : '${domainSnake}_$nameSnake';
  final String commonClassName =
      '${domain.pascalCase}${isEmptyName ? '' : name.pascalCase}';

  String effectiveWriteDir =
      writeDir ?? p.join('lib', 'features', domain, 'presentation', 'bloc');
  // Support template variables in custom writeDir
  if (writeDir != null) {
    effectiveWriteDir = replaceDomainKey(writeDir, domain);
  }
  Directory(effectiveWriteDir).createSync(recursive: true);

  final blocPath = p.join(effectiveWriteDir, '${commonFileName}_bloc.dart');
  final eventPath = p.join(effectiveWriteDir, '${commonFileName}_event.dart');
  final statePath = p.join(effectiveWriteDir, '${commonFileName}_state.dart');

  bool shouldMakeFirst = false;
  for (var f in [eventPath, statePath, blocPath]) {
    if (!File(f).existsSync()) {
      shouldMakeFirst = true;
      break;
    }
  }
  if (shouldMakeFirst) {
    await Process.run("blocz", [
      "make",
      "--domain",
      domain,
      if (!isEmptyName) ...["--name", name],
      "--writeDir",
      effectiveWriteDir,
    ]);
  }

  final eventName = event.camelCase;
  // ignore: non_constant_identifier_names
  final EventName = eventName.pascalCase;

  // Event
  final eventClassName = getFirstClassNameInFile(eventPath);
  var eventContent = File(eventPath).readAsStringSync();
  final eventInsertionPoint = findLastConstFactory(eventPath);
  if (eventInsertionPoint != null) {
    String constructorName = '$eventClassName.$eventName';
    var eventManager = ConstructorManager(
      filePath: eventPath,
      identifier: constructorName,
    );

    String newEventParam = "(dynamic params)";
    String currentEventParam = "()";
    if (apiPath != null && method != null) {
      newEventParam = _eventParam(apiPath, method, true);
    }
    currentEventParam = _eventParam(eventPath, constructorName, false);

    final newEvent =
        '  const factory $constructorName$newEventParam = _${EventName}Requested;';

    if (!eventManager.hasFactoryConstructor()) {
      // write new event
      final eventLines = eventContent.split('\n');
      eventLines.insert(eventInsertionPoint, newEvent);
      File(eventPath).writeAsStringSync(eventLines.join('\n'));
      printSuccess('Created: $constructorName');
    }
    if (update && (newEventParam != currentEventParam)) {
      // printInfo("constructorName: $constructorName");
      // printInfo("newEventParam: $newEventParam");
      // printInfo("currentEventParam: $currentEventParam");
      // update if changed
      final result = eventManager.findOrReplace(replacementText: newEvent);
      final taskResult =
          result.otherProps["findOrReplace_result"] as Map<String, dynamic>?;
      final newSource = taskResult?["newSourceCode"] as String?;
      if (newSource != null) {
        File(eventPath).writeAsStringSync(newSource);
        printWarning(
          'Updated (refresh): $constructorName $currentEventParam -> $newEventParam',
        );
        eventContent = newSource; // update local content for subsequent checks
      }
    }
  }

  // State
  final stateClassName = getFirstClassNameInFile(statePath);
  var stateContent = File(statePath).readAsStringSync();
  final stateInsertionPoint = findLastConstFactory(statePath);
  String newStateParams = "()";
  String currentStateParams = "()";
  if (stateInsertionPoint != null) {
    String constructorName = '$stateClassName.${eventName}Result';
    var stateManager = ConstructorManager(
      filePath: statePath,
      identifier: constructorName,
    );

    // state params
    newStateParams = await _stateParam(apiPath, method, true);
    currentStateParams = await _stateParam(statePath, constructorName, false);
    //     printInfo("""

    // newStateParams: $newStateParams,
    // currentStateParams: $currentStateParams,
    // """);

    final newFactory =
        '  const factory $constructorName$newStateParams = _${EventName}Result;';

    if (!stateManager.hasFactoryConstructor()) {
      final stateLines = stateContent.split('\n');
      stateLines.insert(stateInsertionPoint, newFactory);
      File(statePath).writeAsStringSync(stateLines.join('\n'));
      printSuccess('Created: $constructorName');
    }
    if (update && (newStateParams != currentStateParams)) {
      final result = stateManager.findOrReplace(replacementText: newFactory);
      final taskResult =
          result.otherProps["findOrReplace_result"] as Map<String, dynamic>?;
      final newSource = taskResult?["newSourceCode"] as String?;
      if (newSource != null) {
        File(statePath).writeAsStringSync(newSource);
        printWarning(
          'Updated: $constructorName $currentStateParams -> $newStateParams',
        );
        stateContent = newSource; // update local content for subsequent checks
      }
    }
  }

  // Bloc
  var blocContent = File(blocPath).readAsStringSync();

  final newOn = '    on<_${EventName}Requested>(_on${EventName}Requested);';
  final newMethodName = '_on${EventName}Requested';

  final bool hasOn = blocContent.contains(newOn);
  // ignore: no_leading_underscores_for_local_identifiers
  final bool _hasMethod = hasMethod(blocPath, newMethodName);

  if (_hasMethod && !update) {
    print("$yellow method $newMethodName already exists. skip...");
    return ("", "", "", "");
  }
  if (hasOn && !update) {
    print("$yellow `on` $newOn already exists. skip...");
    return ("", "", "", ""); // Already up-to-date for this event, do nothing.
  }

  final blocLines = blocContent.split('\n');
  bool isDirty = false;

  // Insert method if it's missing. This is inserted near the end of the file.
  if (!_hasMethod) {
    final lastLine = findLastClassbodyLineNumber(blocPath);
    if (lastLine != null) {
      final responseType = (apiPath != null && method != null)
          ? await extractMethodResponseInnerDataType(apiPath, method)
          : null;

      final resHitField = responseType?['hitField'] ?? '';
      final apiClassName = apiPath != null && method != null
          ? findClassNameByMethodName(apiPath, method)
          : null;

      final apiClassNameCamelCase = apiClassName?.camelCase;
      final apiCodeBlock =
          apiPath != null && method != null && apiClassName != null
          ? '''
        try {
          final $apiClassNameCamelCase = GetIt.instance<$apiClassName>();
          final response = await $apiClassNameCamelCase.$method(${_getEventCallParams(apiPath, method)});
          ${resHitField != '' ? '''
          if (response == null) {
            emit(const ${commonClassName}State.failure('No data'));
            return;
          }
          emit(${commonClassName}State.${eventName}Result(response.$resHitField));
''' : '''
          ${newStateParams == "()" ? '''
          emit(${commonClassName}State.${eventName}Result());
          ''' : '''
          emit(${commonClassName}State.${eventName}Result(response));
          '''}
'''}
        } catch (e) {
          emit(${commonClassName}State.failure(e.toString()));
        }
'''
          : '';

      final newMethod =
          '''

  Future<void> $newMethodName(
    _${EventName}Requested event,
    Emitter<${commonClassName}State> emit,
  ) async {
    $apiCodeBlock
  }
''';
      blocLines.insert(lastLine - 1, newMethod);
      isDirty = true;
    }
  }

  // Insert the 'on' call if it's missing. This is inserted earlier in the file.
  // By doing insertions in reverse order, we don't invalidate earlier indices.
  if (!hasOn) {
    final onInsertionPoint = findLast_On_LineNumber(blocPath);
    if (onInsertionPoint != null) {
      blocLines.insert(onInsertionPoint, newOn);
      isDirty = true;
    }
  }

  if (isDirty) {
    File(blocPath).writeAsStringSync(blocLines.join('\n'));
    print('Updated: $blocPath');
  } else if (update && _hasMethod) {
    // try update method body
    final responseType = (apiPath != null && method != null)
        ? await extractMethodResponseInnerDataType(apiPath, method)
        : null;

    final resHitField = responseType?['hitField'] ?? '';
    final apiClassName = apiPath != null && method != null
        ? findClassNameByMethodName(apiPath, method)
        : null;
    final apiClassNameCamelCase = apiClassName?.camelCase;

    final apiCodeBlock =
        apiPath != null && method != null && apiClassName != null
        ? '''
        try {
          final $apiClassNameCamelCase = GetIt.instance<$apiClassName>();
          final response = await $apiClassNameCamelCase.$method(${_getEventCallParams(apiPath, method)});
          ${resHitField != '' ? '''
          if (response == null) {
            emit(const ${commonClassName}State.failure('No data'));
            return;
          }
          emit(${commonClassName}State.${eventName}Result(response.$resHitField));
''' : '''
          ${newStateParams == "()" ? '''
          emit(${commonClassName}State.${eventName}Result());
          ''' : '''
          emit(${commonClassName}State.${eventName}Result(response));
          '''}
'''}
        } catch (e) {
          emit(${commonClassName}State.failure(e.toString()));
        }
'''
        : '';

    final newMethodBody =
        '''async {
    $apiCodeBlock
  }''';

    final manager = MethodManager(
      filePath: blocPath,
      identifier: ".$newMethodName",
    );
    final result = manager.ON_invocationFindByMethodName(
      replacementHandlerBody: newMethodBody,
    );
    final taskResult =
        result.otherProps["ON_invocationFindByMethodName_result"]
            as Map<String, dynamic>?;
    final newSource = taskResult?["fullNewSourceCode"] as String?;
    if (newSource != null) {
      File(blocPath).writeAsStringSync(newSource);
      print('Updated (refresh): $blocPath');
    }
  }
  return (effectiveWriteDir, blocPath, eventPath, statePath);
}

/// Extracts and formats the parameters for calling an API method within a BLoC event handler.
///
/// It parses the method's parameters and returns a string of formatted arguments
/// (e.g., `id, name: event.name`) to be used in the generated code.
String _getEventCallParams(String? fpath, String? method) {
  if (fpath == null || method == null) return '';

  final paramsJson = extractMethodParams(fpath, method);
  if (paramsJson == null) return '';

  final paramsString = jsonDecode(paramsJson)?["data"] as String?;
  if (paramsString == null || paramsString == '()') return '';

  // remove parentheses `()` to get the content, e.g.:
  // "String id, { OrderDomainApplyCouponDTO? applyCouponDTO, }"
  var innerParams = paramsString.substring(1, paramsString.length - 1).trim();
  if (innerParams.isEmpty) return '';

  List<String> positionalParams = [];
  List<String> namedParams = [];

  final namedParamsStartIndex = innerParams.indexOf('{');
  String positionalPartStr;
  String namedPartStr = '';

  if (namedParamsStartIndex != -1) {
    // Case with mixed or only named parameters
    positionalPartStr = innerParams.substring(0, namedParamsStartIndex).trim();
    final namedParamsEndIndex = innerParams.lastIndexOf('}');
    if (namedParamsEndIndex != -1) {
      namedPartStr = innerParams
          .substring(namedParamsStartIndex + 1, namedParamsEndIndex)
          .trim();
    }
  } else {
    // Case with only positional (required or optional) parameters
    positionalPartStr = innerParams.replaceAll(RegExp(r'[\[\]]'), '').trim();
  }

  // Process positional parameters
  if (positionalPartStr.endsWith(',')) {
    positionalPartStr = positionalPartStr.substring(
      0,
      positionalPartStr.length - 1,
    );
  }
  if (positionalPartStr.isNotEmpty) {
    positionalParams = positionalPartStr
        .split(',')
        .where((s) => s.trim().isNotEmpty)
        .map((p) {
          final namePart = p.trim().split('=').first.trim();
          final name = namePart.split(' ').last;
          return 'event.$name';
        })
        .toList();
  }

  // Process named parameters
  if (namedPartStr.endsWith(',')) {
    namedPartStr = namedPartStr.substring(0, namedPartStr.length - 1);
  }
  if (namedPartStr.isNotEmpty) {
    namedParams = namedPartStr.split(',').where((s) => s.trim().isNotEmpty).map(
      (p) {
        final namePart = p.trim().split('=').first.trim();
        final name = namePart.split(' ').last;
        return '$name: event.$name';
      },
    ).toList();
  }

  // Combine and return
  final allParams = [...positionalParams, ...namedParams];
  return allParams.join(', ');
}

Future<String> _stateParam(String? fp, String? method, bool? isApiPath) async {
  if (fp == null || method == null) {
    return "()";
  }
  if (isApiPath != null && isApiPath) {
    Map<String, dynamic>? responseType;
    try {
      responseType = await extractMethodResponseTypeWithField(
        fp,
        method,
        "data,body",
      );
      String responseDataType = "dynamic";
      String result = "()";
      responseDataType = responseType['responseDataType'];
      result = "($responseDataType data)";
      if (result == "(void data)") {
        result = "()";
      }
      return result;
    } catch (e) {
      print("Error: $e");
    }
    return "()";
  } else {
    // current statePath;
    Map<String, dynamic>? eResult = jsonDecode(
      extractConstructorParams(fp, method),
    );
    // printInfo("currentstateparam eResult $eResult");
    final params = eResult?["data"]?["constructorParams"] ?? "()";
    // printInfo("fp: $fp, method:$method ,\neResult $params");
    return params;
  }
}

String _eventParam(String? fp, String method, bool? isApiPath) {
  if (fp == null) return "(dynamic params)";
  if (isApiPath != null && isApiPath) {
    // fp = apiPath
    try {
      Map<String, dynamic>? eResult = jsonDecode(
        extractMethodParams(fp, method) ?? "{}",
      );
      final params = eResult?["data"] ?? "(dynamic params)";
      // printInfo("fp: $fp, method:$method ,\neResult $params");
      return params;
    } catch (e) {
      return "()";
    }
  } else {
    // fp = eventPath
    Map<String, dynamic>? eResult = jsonDecode(
      extractConstructorParams(fp, method),
    );
    final params = eResult?["data"]?["constructorParams"] ?? "()";
    // printInfo("fp: $fp, method:$method ,\neResult $params");
    return params;
  }
}
