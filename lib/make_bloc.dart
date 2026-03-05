import 'dart:io';

import 'package:mustache_template/mustache.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

Future<void> makeBloc(String domain, String? name) async {
  final bool isEmptyName = name == null || name.trim().isEmpty;
  name = isEmptyName ? domain : name;

  final String nameSnake = name.snakeCase;
  final String domainSnake = domain.snakeCase;
  final String commonFileName = isEmptyName
      ? domainSnake
      : '${domainSnake}_${nameSnake}';
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

  final writeDir = p.join('lib', 'features', domain, 'presentation', 'bloc');
  Directory(writeDir).createSync(recursive: true);

  final blocPath = p.join(writeDir, '${commonFileName}_bloc.dart');
  final eventPath = p.join(writeDir, '${commonFileName}_event.dart');
  final statePath = p.join(writeDir, '${commonFileName}_state.dart');

  File(blocPath).writeAsStringSync(bloc);
  File(eventPath).writeAsStringSync(event);
  File(statePath).writeAsStringSync(state);

  print('Generated: $blocPath');
  print('Generated: $eventPath');
  print('Generated: $statePath');
}

String _renderTemplate(String templateContent, Map<String, String> data) {
  final template = Template(templateContent, lenient: true);
  return template.renderString(data);
}

const _blocTemplate = r'''
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
// import 'package:get_it/get_it.dart';

import '{{common_file_name}}_event.dart';
import '{{common_file_name}}_state.dart';

@lazySingleton
class {{CommonFileName}}Bloc extends Bloc<{{CommonFileName}}Event, {{CommonFileName}}State> {
    // dependencies injections
    // final OtherBloc _otherBloc = GetIt.I<OtherBloc>();
    // final OtherUseCase _otherUseCase;

    {{CommonFileName}}Bloc(
        // this._otherUseCase
    ) : super(const {{CommonFileName}}State.initial()) {
        on<{{CommonFileName}}EventLoading>(_on{{CommonFileName}}EventLoading);
    }

    Future<void> _on{{CommonFileName}}EventLoading
    (
        {{CommonFileName}}EventLoading event,
        Emitter<{{CommonFileName}}State> emit
    ) async {
        emit(const {{CommonFileName}}State.loading());
    }
}
''';

const _eventTemplate = r'''
import 'package:freezed_annotation/freezed_annotation.dart';

part '{{common_file_name}}_event.freezed.dart';

@freezed
sealed class {{CommonFileName}}Event with _${{CommonFileName}}Event {
  const factory {{CommonFileName}}Event.loading() = {{CommonFileName}}EventLoading;
}
''';

const _stateTemplate = r'''
import 'package:freezed_annotation/freezed_annotation.dart';

part '{{common_file_name}}_state.freezed.dart';

@freezed
sealed class {{CommonFileName}}State with _${{CommonFileName}}State {
  const factory {{CommonFileName}}State.initial() = _{{CommonFileName}}StateInitialDone;
  const factory {{CommonFileName}}State.loading() = _{{CommonFileName}}StateLoading;
  // const factory {{CommonFileName}}State.loaded(dynamic result) = _{{CommonFileName}}StateLoaded;
  const factory {{CommonFileName}}State.failure(String message) = _{{CommonFileName}}StateFailure;
}
''';
