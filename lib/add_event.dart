import 'dart:convert';
import 'dart:io';

import 'package:blocz/extractMethodListFromClass.dart';
import 'package:blocz/extractMethodParams.dart';
import 'package:blocz/extractMethodResponseTypeWithDataField.dart';
import 'package:blocz/findLastClassbodyLineNumber.dart';
import 'package:blocz/findLastConstFactory.dart';
import 'package:blocz/findLast_On_LineNumber.dart';
import 'package:blocz/getClassName.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

Future<void> addEvent(
  String domain,
  String? name,
  String? event,
  String? apiPath,
  String? method,
) async {
  if (apiPath != null && (event == null || event.trim().isEmpty)) {
    final methods = extractMethodListFromClass(apiPath);
    if (methods != null && methods.isNotEmpty) {
      print(
        'Found ${methods.length} methods in $apiPath. Generating events...',
      );
      for (final methodName in methods) {
        await _addSingleEvent(domain, name, methodName, apiPath, methodName);
      }
      print('Finished generating events from $apiPath.');
    } else {
      print('No public methods found in $apiPath to generate events from.');
    }
    return;
  }

  if (event == null || event.trim().isEmpty) {
    print('Event name is required (or apiPath must be provided).');
    return;
  }

  await _addSingleEvent(domain, name, event, apiPath, method ?? event);
}

Future<void> _addSingleEvent(
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
      return;
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
        '  const factory $eventClassName.${eventName}Requested$params = _$eventClassName${EventName}Requested;';
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
  if (stateInsertionPoint != null) {
    final responseType = (apiPath != null && method != null)
        ? await extractMethodResponseInnerDataType(apiPath, method)
        : null;
    var stateParams = responseType != null
        ? '(${responseType['responseDataType']} data)'
        : '(dynamic data)';
    if (stateParams == "(void data)") {
      stateParams = "()";
    }
    final newState =
        '  const factory $stateClassName.${eventName}Result$stateParams = _$stateClassName${EventName}Result;';
    if (!stateContent.contains(newState)) {
      final stateLines = stateContent.split('\n');
      stateLines.insert(stateInsertionPoint, newState);
      File(statePath).writeAsStringSync(stateLines.join('\n'));
      print('Updated: $statePath');
    }
  }

  // Bloc
  var blocContent = File(blocPath).readAsStringSync();

  final newOn =
      '    on<_${commonClassName}Event${EventName}Requested>(_on${commonClassName}Event${EventName}Requested);';
  final newMethodName = '_on${commonClassName}Event${EventName}Requested';

  final bool hasOn = blocContent.contains(newOn);
  final bool hasMethod = blocContent.contains(newMethodName);

  if (hasOn && hasMethod) {
    return; // Already up-to-date for this event, do nothing.
  }

  final blocLines = blocContent.split('\n');
  bool isDirty = false;

  // Insert method if it's missing. This is inserted near the end of the file.
  if (!hasMethod) {
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
          emit(${commonClassName}State.${eventName}Result());
'''}
        } catch (e) {
          emit(${commonClassName}State.failure(e.toString()));
        }
'''
          : '';

      final newMethod =
          '''

  Future<void> $newMethodName(
    _${commonClassName}Event${EventName}Requested event,
    Emitter<${commonClassName}State> emit,
  ) async {
    $apiCodeBlock
  }
''';
      blocLines.insert(lastLine, newMethod);
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
