import 'dart:io';

import 'package:blocz/_internal/colors.dart';
import 'package:blocz/add_event.dart';
import 'package:blocz/makeUtils.dart';
import 'package:mustache_template/mustache.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

Future<void> makeBloc(
  String domain,
  String? name,
  String? apiPath, {
  String? writeDir,
}) async {
  final bool isEmptyName = name == null || name.trim().isEmpty;
  name = isEmptyName ? domain : name;

  final String nameSnake = name.snakeCase;
  final String domainSnake = domain.snakeCase;
  final String commonFileName = isEmptyName
      ? domainSnake
      : '${domainSnake}_$nameSnake';
  final String commonClassName = commonFileName.pascalCase;

  final Map<String, String> data = {
    'name': name,
    'Name': name.pascalCase,
    'name_': nameSnake,
    'domain': domain,
    'Domain': domain.pascalCase,
    'domain_': domainSnake,
    'common_file_name': commonFileName,
    'CommonFileName': commonClassName,
  };

  final bloc = _renderTemplate(_blocTemplate, data);
  final event = _renderTemplate(_eventTemplate, data);
  final state = _renderTemplate(_stateTemplate, data);

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
  // check exists
  if (!File(blocPath).existsSync()) {
    File(blocPath).writeAsStringSync(bloc);
    printSuccess('Generated: $blocPath');
  }
  if (!File(eventPath).existsSync()) {
    File(eventPath).writeAsStringSync(event);
    printSuccess('Generated: $eventPath');
  }
  if (!File(statePath).existsSync()) {
    File(statePath).writeAsStringSync(state);
    printSuccess('Generated: $statePath');
  }

  if (apiPath != null && apiPath.trim().isNotEmpty) {
    printInfo('\napiPath provided. Adding events from $apiPath...');
    await addEvent(
      domain,
      isEmptyName ? null : name,
      null,
      apiPath,
      null,
      writeDir: effectiveWriteDir,
    );

    printSuccess('Finished adding events from apiPath: $apiPath .');
  }
}

String _renderTemplate(String templateContent, Map<String, String> data) {
  final template = Template(templateContent, lenient: true);
  return template.renderString(data);
}

const _blocTemplate = r'''
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';

part '{{common_file_name}}_event.dart';
part '{{common_file_name}}_state.dart';
part '{{common_file_name}}_bloc.freezed.dart';

@lazySingleton
class {{CommonFileName}}Bloc extends Bloc<{{CommonFileName}}Event, {{CommonFileName}}State> {
    // dependencies injections
    // final OtherBloc _otherBloc = GetIt.I<OtherBloc>();
    // final OtherUseCase _otherUseCase;

    {{CommonFileName}}Bloc(
        // this._otherUseCase
    ) : super(const {{CommonFileName}}State.initial()) {
        on<_{{CommonFileName}}EventLoading>(_on{{CommonFileName}}EventLoading);
    }

    Future<void> _on{{CommonFileName}}EventLoading
    (
        _{{CommonFileName}}EventLoading event,
        Emitter<{{CommonFileName}}State> emit
    ) async {
        emit(const {{CommonFileName}}State.loading());
    }
}
''';

const _eventTemplate = r'''
part of '{{common_file_name}}_bloc.dart';

@freezed
sealed class {{CommonFileName}}Event with _${{CommonFileName}}Event {
  const factory {{CommonFileName}}Event.loading() = _{{CommonFileName}}EventLoading;
}
''';

const _stateTemplate = r'''
part of '{{common_file_name}}_bloc.dart';

@freezed
sealed class {{CommonFileName}}State with _${{CommonFileName}}State {
  const factory {{CommonFileName}}State.initial() = _InitialDone;
  const factory {{CommonFileName}}State.loading() = _Loading;
  const factory {{CommonFileName}}State.failure(String message) = _Failure;
}
''';
