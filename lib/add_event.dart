import 'dart:convert';
import 'dart:io';

import 'package:blocz/_internal/colors.dart';
import 'package:blocz/_internal/managers/ConstructorManager.dart';
import 'package:blocz/extractMethodInvocationArgs.dart';
import 'package:blocz/extractMethodListFromClass.dart';
import 'package:blocz/replaceMethodInvocationArgs.dart';
import 'package:blocz/extractMethodResponseTypeWithDataField.dart';
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

      // run build runner and format
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
    printError(
      ' ❗️ Domain (or event) name is required (or apiPath must be provided).',
    );
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
    if (File(f).existsSync() == false) {
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

  // Event
  final eventName = event.camelCase;
  // ignore: non_constant_identifier_names
  final EventName = eventName.pascalCase;
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
      newEventParam = eventParam(apiPath, method, true);
    }
    currentEventParam = eventParam(eventPath, constructorName, false);

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
      final newSource = newSourCode(eventManager, newEvent);
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
    newStateParams = await stateParam(apiPath, method, true);
    currentStateParams = await stateParam(statePath, constructorName, false);
    final newFactory =
        '  const factory $constructorName$newStateParams = _${EventName}Result;';

    if (!stateManager.hasFactoryConstructor()) {
      final stateLines = stateContent.split('\n');
      stateLines.insert(stateInsertionPoint, newFactory);
      File(statePath).writeAsStringSync(stateLines.join('\n'));
      printSuccess('Created: $constructorName');
    }
    if (update && (newStateParams != currentStateParams)) {
      final newSource = newSourCode(stateManager, newFactory);
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

  final onRegistration =
      'on<_${EventName}Requested>(_on${EventName}Requested);';
  final onMethodName = '_on${EventName}Requested';

  // ignore: no_leading_underscores_for_local_identifiers
  final bool _hasOnRegistration = blocContent.contains(onRegistration);
  // ignore: no_leading_underscores_for_local_identifiers
  final bool _hasOnMethod = hasMethod(blocPath, onMethodName);
  if (!update) {
    if (_hasOnRegistration) {
      printWarning(
        "event handler registration `$onRegistration` already exists. skip...",
      );

      // printWarning("use `--update` to force update");
      return ("", "", "", ""); // Already up-to-date for this event, do nothing.
    }
    if (_hasOnMethod) {
      printWarning("method `$onMethodName` already exists. skip...");
      // printWarning("use `--update` to force update");
      return ("", "", "", "");
    }
  }

  final blocLines = blocContent.split('\n');
  bool isDirty = false;

  // Insert method if it's missing. This is inserted near the end of the file.
  if (!_hasOnMethod) {
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
          final response = await $apiClassNameCamelCase.$method(${getEventCallArgs(apiPath, method)});
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

  Future<void> $onMethodName(
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
  if (!_hasOnRegistration) {
    final onInsertionPoint = findLast_On_LineNumber(blocPath);
    if (onInsertionPoint != null) {
      blocLines.insert(onInsertionPoint, onRegistration);
      isDirty = true;
    }
  }

  // start writing to bloc file
  if (isDirty) {
    File(blocPath).writeAsStringSync(blocLines.join('\n'));
    print('Updated: $blocPath');
  } else if (update && _hasOnMethod) {
    // try update method body
    final newCallArgs = getEventCallArgs(apiPath, method);
    final newCallArgsWithParentheses = "($newCallArgs)";
    final currentCallArgsWithParentheses =
        jsonDecode(
              extractMethodInvocationArgs(blocPath, method) ?? "{}",
            )['data']
            as String?;
    //     print('''
    //   newCallArgsWithParentheses: $newCallArgsWithParentheses
    //   currentCallArgsWithParentheses: $currentCallArgsWithParentheses
    //   isSame: ${newCallArgsWithParentheses == currentCallArgsWithParentheses}
    // ''');

    if (newCallArgsWithParentheses != currentCallArgsWithParentheses) {
      final updatedSource = replaceMethodInvocationArgs(
        blocPath,
        method!,
        newCallArgsWithParentheses,
      );
      if (updatedSource != null) {
        File(blocPath).writeAsStringSync(updatedSource);
        print('Updated (refresh args): $blocPath');
      } else {
        printWarning(
          "Could not find method call to `.$method` in $blocPath for surgical update.",
        );
      }
    }
  }
  return (effectiveWriteDir, blocPath, eventPath, statePath);
}
