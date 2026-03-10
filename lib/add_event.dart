import 'dart:convert';
import 'dart:io';

import 'package:blocz/_internal/colors.dart';
import 'package:blocz/extractMethodListFromClass.dart';
import 'package:blocz/extractMethodParams.dart';
import 'package:blocz/extractMethodResponseTypeWithDataField.dart';
import 'package:blocz/extractMethodResponseTypeWithField.dart';
import 'package:blocz/findLastClassbodyLineNumber.dart';
import 'package:blocz/findLastConstFactory.dart';
import 'package:blocz/findLast_On_LineNumber.dart';
import 'package:blocz/getClassName.dart';
import 'package:blocz/onDoneUtils.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

Future<void> addEvent(
  String domain,
  String? name,
  String? event,
  String? apiPath,
  String? method,
) async {
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
          // skip ...WithHttpInfo method
          continue;
        }
        if (method != null &&
            method.trim().isNotEmpty &&
            methodName != method) {
          // skip method that is not the one specified
          continue;
        }
        results.add(
          await _addSingleEvent(domain, name, methodName, apiPath, methodName),
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

  // signle event generate
  final result = await _addSingleEvent(
    domain,
    name,
    event,
    apiPath,
    method ?? event,
  );
  if (result.$1.isEmpty) {
    printWarning("No events generated.");
    return;
  }
  runBuildRunner(result.$1);
  runDartFormat(result.$1);
  printSuccess(' ✅ Finished generating events from $apiPath.');
}

Future<(String, String, String, String)> _addSingleEvent(
  String domain,
  String? name,
  String event,
  String? apiPath,
  String? method,
) async {
  final bool isEmptyName = name == null || name.trim().isEmpty;
  name = isEmptyName ? domain : name;

  final String nameSnake = name.snakeCase;
  final String domainSnake = domain.snakeCase;
  final String commonFileName = isEmptyName
      ? nameSnake
      : '${domainSnake}_${nameSnake}';
  final String commonClassName =
      '${domain.pascalCase}${isEmptyName ? '' : name.pascalCase}';

  final writeDir = p.join('lib', 'features', domain, 'presentation', 'bloc');
  final blocPath = p.join(writeDir, '${commonFileName}_bloc.dart');
  final eventPath = p.join(writeDir, '${commonFileName}_event.dart');
  final statePath = p.join(writeDir, '${commonFileName}_state.dart');

  for (var f in [eventPath, statePath, blocPath]) {
    if (!File(f).existsSync()) {
      print('File not found: $f');
      return ("", "", "", "");
    }
  }

  final eventName = event.camelCase;
  final EventName = eventName.pascalCase;

  // Event
  final eventClassName = getFirstClassNameInFile(eventPath);
  var eventContent = File(eventPath).readAsStringSync();
  final eventInsertionPoint = findLastConstFactory(eventPath);
  if (eventInsertionPoint != null) {
    String params = "(dynamic params)";
    if (apiPath != null && method != null) {
      params =
          jsonDecode(extractMethodParams(apiPath, method) ?? "{}")?["data"] ??
          "(dynamic params)";
    }
    final newEvent =
        '  const factory $eventClassName.${eventName}$params = _${EventName}Requested;';
    if (!eventContent.contains(newEvent)) {
      final eventLines = eventContent.split('\n');
      eventLines.insert(eventInsertionPoint, newEvent);
      File(eventPath).writeAsStringSync(eventLines.join('\n'));
      print('Updated: $eventPath');
    }
  }

  // State
  final stateClassName = getFirstClassNameInFile(statePath);
  var stateContent = File(statePath).readAsStringSync();
  final stateInsertionPoint = findLastConstFactory(statePath);
  String stateParams = "()";
  if (stateInsertionPoint != null) {
    final responseType = (apiPath != null && method != null)
        ? await extractMethodResponseTypeWithField(apiPath, method, "data,body")
        : null;
    // print("// responseType:: \\\\");
    // print(responseType);
    // print("\\\\ responseType:: //");
    String responseDataType = "dynamic";
    if (responseType != null) {
      responseDataType = responseType['responseDataType'];
      stateParams = "($responseDataType data)";
      if (stateParams == "(void data)") {
        stateParams = "()";
      }
    }

    final newState =
        '  const factory $stateClassName.${eventName}Result$stateParams = _${EventName}Result;';
    if (!stateContent.contains(newState)) {
      final stateLines = stateContent.split('\n');
      stateLines.insert(stateInsertionPoint, newState);
      File(statePath).writeAsStringSync(stateLines.join('\n'));
      print('Updated: $statePath');
    }
  }

  // Bloc
  var blocContent = File(blocPath).readAsStringSync();

  final newOn = '    on<_${EventName}Requested>(_on${EventName}Requested);';
  final newMethodName = '_on${EventName}Requested';

  final bool hasOn = blocContent.contains(newOn);
  // ignore: no_leading_underscores_for_local_identifiers
  final bool _hasMethod = hasMethod(blocPath, newMethodName);

  if (_hasMethod) {
    print("$yellow method $newMethodName already exists. skip...");
    return ("", "", "", "");
  }
  if (hasOn) {
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
      final apiClassName = apiPath != null
          ? getFirstClassNameInFile(apiPath)
          : null;

      final apiCodeBlock =
          apiPath != null && method != null && apiClassName != null
          ? '''
        try {
          final injectedApi = GetIt.instance<$apiClassName>();
          final response = await injectedApi.$method(${_getEventCallParams(apiPath, method)});
          ${resHitField != '' ? '''
          if (response == null) {
            emit(const ${commonClassName}State.failure('No data'));
            return;
          }
          emit(${commonClassName}State.${eventName}Result(response.$resHitField));
''' : '''
          ${stateParams == "()" ? '''
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
  }
  return (writeDir, blocPath, eventPath, statePath);
}

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
