import 'dart:io';

import 'package:mustache_template/mustache.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

Future<void> makeBloc(String domain, String? name) async {
  final bool isEmptyName = name == null || name.trim().isEmpty;
  name = isEmptyName ? domain : name;

  final String nameSnake = name!.snakeCase;
  final String domainSnake = domain.snakeCase;
  final String commonFileName = isEmptyName ? domainSnake : '${domainSnake}_${nameSnake}';
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

  final bloc = _renderTemplate('bloc', data);
  final event = _renderTemplate('event', data);
  final state = _renderTemplate('state', data);

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

String _renderTemplate(String templateName, Map<String, String> data) {
  final templatePath = p.join(
    p.dirname(Platform.script.toFilePath()),
    'templates',
    '$templateName.dart.hbs',
  );
  final templateContent = File(templatePath).readAsStringSync();
  final template = Template(templateContent, lenient: true);
  return template.renderString(data);
}
