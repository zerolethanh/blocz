import 'dart:io';

import 'package:floc_helper/extractMethodParams.dart';
import 'package:floc_helper/extractMethodResponseTypeWithDataField.dart';
import 'package:floc_helper/findLastClassbodyLineNumber.dart';
import 'package:floc_helper/findLastConstFactory.dart';
import 'package:floc_helper/findLast_On_LineNumber.dart';
import 'package:floc_helper/getClassName.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

Future<void> addEvent(String domain, String? name, String? event, String? apiPath, String? method) async {
  if (event == null || event.trim().isEmpty) {
    print('Event name is required');
    return;
  }

  final bool isEmptyName = name == null || name.trim().isEmpty;
  name = isEmptyName ? domain : name;

  final String nameSnake = name.snakeCase;
  final String domainSnake = domain.snakeCase;
  final String commonFileName = isEmptyName ? nameSnake : '${domainSnake}_${nameSnake}';
  final String commonClassName = '${domain.pascalCase}${isEmptyName ? '' : name.pascalCase}';

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
  final eventContent = File(eventPath).readAsStringSync();
  final eventLines = eventContent.split('\n');
  final eventInsertionPoint = findLastConstFactory(eventPath);
  if (eventInsertionPoint != null) {
    final params = (apiPath != null && method != null) ? extractMethodParams(apiPath, method) ?? '(dynamic params)' : '(dynamic params)';
    final newEvent = '  const factory $eventClassName.${eventName}Requested$params = $eventClassName${EventName}Requested;';
    eventLines.insert(eventInsertionPoint, newEvent);
    File(eventPath).writeAsStringSync(eventLines.join('\n'));
    print('Updated: $eventPath');
  }

  // State
  final stateClassName = getFirstClassNameInFile(statePath);
  final stateContent = File(statePath).readAsStringSync();
  final stateLines = stateContent.split('\n');
  final stateInsertionPoint = findLastConstFactory(statePath);
  if (stateInsertionPoint != null) {
    final responseType = (apiPath != null && method != null) ? await extractMethodResponseInnerDataType(apiPath, method) : null;
    final stateParams = responseType != null ? '(${responseType['responseDataType']} data)' : '(dynamic data)';
    final newState = '  const factory $stateClassName.${eventName}Result$stateParams = $stateClassName${EventName}Result;';
    stateLines.insert(stateInsertionPoint, newState);
    File(statePath).writeAsStringSync(stateLines.join('\n'));
    print('Updated: $statePath');
  }

  // Bloc
  final blocContent = File(blocPath).readAsStringSync();
  final blocLines = blocContent.split('\n');
  final onInsertionPoint = findLast_On_LineNumber(blocPath);
  if (onInsertionPoint != null) {
    final newOn = '    on<${commonClassName}Event${EventName}Requested>(_on${commonClassName}Event${EventName}Requested);';
    blocLines.insert(onInsertionPoint, newOn);

    final lastLine = findLastClassbodyLineNumber(blocPath);
    if (lastLine != null) {
      final responseType = (apiPath != null && method != null) ? await extractMethodResponseInnerDataType(apiPath, method) : null;
      final resHitField = responseType?['hitField'] ?? 'body';
      final apiClassName = apiPath != null ? getFirstClassNameInFile(apiPath) : null;

      final apiCodeBlock = apiPath != null && method != null && apiClassName != null
          ? '''
        try {
           final injectedApi = GetIt.instance<$apiClassName>();
          final response = await injectedApi.$method(${_getEventCallParams(apiPath, method)});
          if (response == null || response.$resHitField == null) {
            emit(const ${commonClassName}State.failure('No data'));
            return;
          }
          emit(${commonClassName}State.${eventName}Result(response.$resHitField));
        } catch (e) {
          emit(${commonClassName}State.failure(e.toString()));
        }
'''
          : '';

      final newMethod = '''

  Future<void> _on${commonClassName}Event${EventName}Requested(
    ${commonClassName}Event${EventName}Requested event,
    Emitter<${commonClassName}State> emit,
  ) async {
    $apiCodeBlock
  }
''';
      blocLines.insert(lastLine, newMethod);
    }

    File(blocPath).writeAsStringSync(blocLines.join('\n'));
    print('Updated: $blocPath');
  }
}

String _getEventCallParams(String? fpath, String? method) {
  if (fpath == null || method == null) return '';
  final params = extractMethodParams(fpath, method);
  if (params == null) return '';

  final paramString = params.replaceAll(RegExp(r'[()]'), '');
  if (paramString.isEmpty) return '';
  final paramList = paramString.split(',');
  return paramList.map((p) {
    final parts = p.trim().split(' ');
    final name = parts.last;
    return 'event.$name';
  }).join(', ');
}
