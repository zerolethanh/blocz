import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:blocz/_internal/colors.dart';
import 'package:blocz/_internal/getSdkPath.dart';
import 'package:blocz/_internal/managers/MethodManager.dart';
import 'package:blocz/add_event.dart';
import 'package:blocz/extractCls.dart';
import 'package:blocz/extractConstructorListFromClass.dart';
import 'package:blocz/extractConstructorParams.dart';
import 'package:blocz/extractConstructorParamsAndItsFields.dart';
import 'package:blocz/extractMethodListFromClass.dart';
import 'package:blocz/extractMethodParams.dart';
import 'package:blocz/extractMethodResponseType.dart';
import 'package:blocz/extractMethodResponseTypeWithDataField.dart';
import 'package:blocz/extractMethodResponseTypeWithField.dart';
import 'package:blocz/findLastClassbodyLineNumber.dart';
import 'package:blocz/findLastConstFactory.dart';
import 'package:blocz/findLast_On_LineNumber.dart';
import 'package:blocz/getClassName.dart';
import 'package:blocz/get_project_root_path.dart';
import 'package:blocz/import_clause_to_path.dart';
import 'package:blocz/make_bloc.dart';
import 'package:path/path.dart';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser();

  // Define command-line arguments
  parser.addFlag(
    'help',
    abbr: 'h',
    help: 'Show this help message',
    negatable: false,
  );
  parser.addFlag('force', abbr: 'f', help: 'force write', defaultsTo: false);

  parser.addCommand('make', parser.addCommand('make:bloc'))
    ..addSeparator("Generate BLoC, State, and Event files")
    ..addOption(
      'domain',
      abbr: 'd',
      help: 'Domain name (required)',
      mandatory: true,
    )
    ..addOption(
      'name',
      abbr: 'n',
      help:
          'The name of the BLoC, or a sub-domain/sub-feature name (optional) (e.g., authentication)',
    )
    ..addOption(
      'apiPath',
      abbr: 'a',
      help: 'Path to the API service file (optional)',
    )
    ..addOption(
      'writeDir',
      abbr: 'w',
      help: 'Custom directory to generate BLoC files (optional)',
    );

  parser.addCommand('add:event')
    ..addSeparator("Add an event to an existing BLoC")
    ..addOption(
      'domain',
      abbr: 'd',
      help: 'Domain name (required)',
      mandatory: true,
    )
    ..addOption(
      'name',
      abbr: 'n',
      help:
          'The name of the BLoC, or a sub-domain/sub-feature name (optional) (e.g., authentication)',
    )
    ..addOption('event', abbr: 'e', help: 'Event name (optional)')
    ..addOption(
      'apiPath',
      abbr: 'a',
      help: 'Path to the API service file (optional)',
    )
    ..addOption(
      'method',
      abbr: 'm',
      help: 'Target method name in the API file (optional)',
    )
    ..addOption(
      'writeDir',
      abbr: 'w',
      help: 'Custom directory to find BLoC files (optional)',
    );

  parser.addCommand('pr', parser.addCommand("project:root"))
    ..addSeparator("Get project root")
    ..addOption(
      'path',
      abbr: 'p',
      help: 'Source file full path (optional); defaults to current directory',
    );

  parser.addCommand('sdk:path').addSeparator("Get dart sdk path");

  parser.addCommand('class:extract')
    ..addSeparator("Extract class declaration")
    ..addOption('path', abbr: 'p', help: 'Source file full path');

  parser.addCommand('constructor:params')
    ..addSeparator("Extract constructor parameters")
    ..addOption(
      'path',
      abbr: 'p',
      help: 'Source file full path (required)',
      mandatory: true,
    )
    ..addOption('name', abbr: 'n', help: 'Constructor name (optional)');

  parser.addCommand('constructor:params:and:fields')
    ..addSeparator("Extract constructor params and their corresponding fields")
    ..addOption(
      'path',
      abbr: 'p',
      help: 'Source file full path (required)',
      mandatory: true,
    )
    ..addOption('name', abbr: 'n', help: 'Constructor name (optional)');

  // ... other commands
  parser.addCommand('clause:import')
    ..addSeparator(
      "Get the import clause for a file (e.g., import 'package:abc/abc.dart')",
    )
    ..addOption(
      'path',
      abbr: 'p',
      help: 'Source file full path (required)',
      mandatory: true,
    );

  parser.addCommand('find:last:on:line:number')
    ..addSeparator("Find the last line number for a specific pattern")
    ..addOption(
      'path',
      abbr: 'p',
      help: 'Source file full path (required)',
      mandatory: true,
    );

  parser.addCommand('find:last:const:factory')
    ..addSeparator("Find the last 'const factory' in a file")
    ..addOption(
      'path',
      abbr: 'p',
      help: 'Source file full path (required)',
      mandatory: true,
    );

  parser.addCommand('find:last:class:body:line:number')
    ..addSeparator("Find the last line number of a class body")
    ..addOption(
      'path',
      abbr: 'p',
      help: 'Source file full path (required)',
      mandatory: true,
    );

  parser.addCommand("class:name:get")
    ..addSeparator("Get the primary class name from a file")
    ..addOption(
      'path',
      abbr: 'p',
      help: 'Source file full path (required)',
      mandatory: true,
    );

  parser.addCommand("class:name:list")
    ..addSeparator("List all class names in a file")
    ..addOption(
      'path',
      abbr: 'p',
      help: 'Source file full path (required)',
      mandatory: true,
    );

  parser.addCommand("method:params", parser.addCommand("method:params2"))
    ..addSeparator("Extract parameters from a method")
    ..addOption(
      'path',
      abbr: 'p',
      help: 'Source file full path (required)',
      mandatory: true,
    )
    ..addOption('method', abbr: 'm', help: 'Method name (optional)');

  parser.addCommand("method:response:type")
    ..addSeparator("Extract the response type from a method")
    ..addOption(
      'path',
      abbr: 'p',
      help: 'Source file full path (required)',
      mandatory: true,
    )
    ..addOption(
      'method',
      abbr: 'm',
      help: 'Method name (required)',
      mandatory: true,
    );

  parser.addCommand("method:response:inner:data:type")
    ..addSeparator(
      "Extract inner 'data' or 'body' field type from a method's response",
    )
    ..addOption(
      'path',
      abbr: 'p',
      help: 'Source file full path (required)',
      mandatory: true,
    )
    ..addOption(
      'method',
      abbr: 'm',
      help: 'Method name (required)',
      mandatory: true,
    );

  parser.addCommand("method:response:inner:field:type")
    ..addSeparator("Extract a specific field type from a method's response")
    ..addOption(
      'path',
      abbr: 'p',
      help: 'Source file full path (required)',
      mandatory: true,
    )
    ..addOption(
      'method',
      abbr: 'm',
      help: 'Method name (required)',
      mandatory: true,
    )
    ..addOption(
      'fieldName',
      abbr: 'f',
      help: 'Field names (can be comma-separated) (optional)',
    );

  parser.addCommand("method:list")
    ..addSeparator("List all methods in a class")
    ..addOption(
      'path',
      abbr: 'p',
      help: 'Source file full path (required)',
      mandatory: true,
    )
    ..addOption('class', abbr: 'c', help: 'Class name (optional)');

  parser.addCommand("method:list2")
    ..addSeparator("List all methods in a class or file")
    ..addOption(
      'path',
      abbr: 'p',
      help: 'Source file full path (required)',
      mandatory: true,
    )
    ..addOption(
      'identifier',
      abbr: 'i',
      help: 'Identifier to find (e.g., PetBloc) (optional)',
    );

  parser.addCommand('constructor:list')
    ..addSeparator("List all constructors in a class")
    ..addOption(
      'path',
      abbr: 'p',
      help: 'Source file full path (required)',
      mandatory: true,
    )
    ..addOption('class', abbr: 'c', help: 'Class name (optional)');

  final commandList = parser.commands;
  // printInfo(commandList);
  if (arguments.isNotEmpty &&
      !arguments[0].startsWith('-') &&
      commandList[arguments[0]] == null) {
    printError("Command '${arguments[0]}' not found.");
    return;
  }
  try {
    final parserResult = parser.parse(arguments);

    if (parserResult['help'] as bool || parserResult.command == null) {
      print('Available commands:');

      final commandGroups = <ArgParser, List<String>>{};
      final groupOrder = <ArgParser>[];

      parser.commands.forEach((name, command) {
        if (!commandGroups.containsKey(command)) {
          groupOrder.add(command);
          commandGroups[command] = [];
        }
        commandGroups[command]!.add(name);
      });

      for (final command in groupOrder) {
        final names = commandGroups[command]!;
        final displayNames = names.join(' | ');
        print("$green$displayNames$reset: ${command.usage}\n");
      }

      print('\n${parser.usage}');
      exit(0);
    }

    final command = parserResult.command!;
    String? pathParam;
    try {
      pathParam = command.option('path');
      if (pathParam != null && pathParam.isNotEmpty) {
        if (!pathParam.endsWith(".dart")) {
          printError("--path should be a .dart file path");
          exit(0);
        }
      }
    } catch (e) {
      // print(e);
    }

    // printInfo("↓↓↓ result ↓↓↓");
    switch (command.name) {
      case 'make':
      case 'make:bloc':
        final domain = command['domain'] as String;
        final name = command['name'] as String?;
        var apiPath = command['apiPath'] as String?;
        if (apiPath != null && apiPath.isNotEmpty) {
          apiPath = toAbsPath(apiPath);
        }
        final writeDir = command['writeDir'] as String?;
        await makeBloc(domain, name, apiPath, writeDir: writeDir);
        break;
      case 'add:event':
      case 'add':
        final domain = command['domain'] as String;
        final name = command['name'] as String?;
        final event = command['event'] as String?;
        var apiPath = command['apiPath'] as String?;
        if (apiPath != null && apiPath.isNotEmpty) {
          apiPath = toAbsPath(apiPath);
        }
        final method = command['method'] as String?;
        final writeDir = command['writeDir'] as String?;
        await addEvent(
          domain,
          name,
          event,
          apiPath,
          method,
          writeDir: writeDir,
        );
        break;
      case 'pr':
      case 'project:root':
        print(getProjectRootPath(scriptPath: pathParam));
        break;
      case 'sdk:path':
        print(getSdkPath());
        break;
      // case 'extractCls':
      case 'class:extract':
        _ensurePathParam(pathParam);
        extractCls(pathParam!);
        break;
      case 'constructor:params':
        _ensurePathParam(pathParam);
        final constructorName = command.option('name');
        final result = extractConstructorParams(pathParam!, constructorName);
        print(result);
        break;
      case 'constructor:params:and:fields':
        _ensurePathParam(pathParam);
        final constructorName = command.option('name');
        final result = extractConstructorParamsAndItsFields(
          pathParam!,
          constructorName,
        );
        print(result);
        break;
      // ... other cases
      //   case 'importClauseToPath':
      case 'clause:import':
        _ensurePathParam(pathParam);
        importClauseToPath(pathParam!);
        break;
      case 'find:last:on:line:number':
        _ensurePathParam(pathParam);
        findLast_On_LineNumber(pathParam!);
        break;
      case 'find:last:const:factory':
        _ensurePathParam(pathParam);
        findLastConstFactory(pathParam!);
        break;
      case 'find:last:class:body:line:number':
        _ensurePathParam(pathParam);
        findLastClassbodyLineNumber(pathParam!);
        break;
      // case 'getClassName':
      case 'class:name:get':
        _ensurePathParam(pathParam);
        final result = getFirstClassNameInFile(pathParam!);
        print(result);
        break;
      // case 'getClassNameList':
      case 'class:name:list':
        _ensurePathParam(pathParam);
        final result = getClassNameListInFile(pathParam!);
        print(result);
        break;
      // case 'extractMethodParams':
      case 'method:params':
        _ensurePathParam(pathParam);
        final methodName = command.option('method');
        final params = extractMethodParams(pathParam!, methodName);
        print(params);
        break;
      case 'method:params2':
        _ensurePathParam(pathParam);
        final methodName = command.option('method');
        final params = MethodManager(
          filePath: pathParam!,
          identifier: ".$methodName",
        );
        params.paramsList().expose();
        break;
      // case 'extractMethodResponseType':
      case 'method:response:type':
        _ensurePathParam(pathParam);
        final methodName = command.option('method');
        _throwIfNotTrue(methodName != null, "--method or -m required");
        final responseType = extractMethodResponseType(pathParam!, methodName!);
        print(responseType);
        break;
      // case 'extractMethodResponseTypeWithDataField':
      case 'method:response:inner:data:type':
        _ensurePathParam(pathParam);
        final methodName = command.option('method');
        _throwIfNotTrue(methodName != null, "--method or -m required");
        final responseType = await extractMethodResponseInnerDataType(
          pathParam!,
          methodName!,
        );
        print(JsonEncoder.withIndent('  ').convert(responseType));
        break;
      // case 'extractMethodResponseTypeWithField':
      case 'method:response:inner:field:type':
        _ensurePathParam(pathParam);
        final methodName = command.option('method');
        dynamic fieldName = command.option('fieldName') ?? "data,body";
        _throwIfNotTrue(methodName != null, "--method or -m required");
        final responseType = await extractMethodResponseTypeWithField(
          pathParam!,
          methodName!,
          fieldName,
        );
        print(JsonEncoder.withIndent('  ').convert(responseType));
        break;
      // case 'extractMethodListFromClass':
      case 'method:list':
        _ensurePathParam(pathParam);
        final className = command.option('class');
        final methods = extractMethodListFromClass(pathParam!, className);
        print(jsonEncode(methods));
        break;
      case 'method:list2':
        _ensurePathParam(pathParam);
        final identifier = command.option('identifier');
        final result = MethodManager(
          filePath: pathParam!,
          identifier: identifier ?? "",
        ).listAllMethods().toString();
        print(result);
        break;
      // case 'extractConstructorListFromClass':
      case 'constructor:list':
        _ensurePathParam(pathParam);
        final className = command.option('class');
        final result = extractConstructorListFromClass(pathParam!, className);
        print(jsonEncode(result.toSet().toList()));
        break;
    }
  } on FormatException catch (e) {
    printError('ArgParser FormatException: ${e.message}');
    exit(1);
  } catch (e, stackTrace) {
    printError("General error: ${e.toString()}");
    print(stackTrace);
    exit(2);
  }
}

void _ensurePathParam(String? pathParam) {
  if (pathParam == null || pathParam.isEmpty) {
    _throwIfNotTrue(false, "--path or -p is required");
  }
}

void _throwIfNotTrue(bool flag, String? error) {
  if (!flag) {
    print("$red error: $error $reset");
    exit(1);
  }
}

void printResult(dynamic result) {
  print("$blue --- START Result --- $reset");
  print("$green$result$reset");
  print("$blue --- END Result --- $reset");
}

String toAbsPath(String fp) {
  if (isAbsolute(fp)) {
    return fp;
  }
  String? r = getProjectRootPath();
  if (r == null || r.isEmpty) {
    return fp;
  }
  return normalize(join(r, fp));
}
