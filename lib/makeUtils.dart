import 'dart:convert';
import 'dart:io';

import 'package:blocz/_internal/colors.dart';
import 'package:blocz/_internal/managers/ConstructorManager.dart';
import 'package:blocz/extractConstructorParams.dart';
import 'package:blocz/extractMethodInvocationArgs.dart';
import 'package:blocz/extractMethodParams.dart';
import 'package:blocz/extractMethodResponseTypeWithField.dart';
import 'package:recase/recase.dart';

void runDartFormat(String dir) {
  printInfo("running dart format for $dir ...");
  // run format
  Process.runSync("dart", ["run", "format", dir]);
}

void runBuildRunner(String dir) {
  printInfo("running build_runner...");
  // run build_runner
  Process.runSync("dart", [
    "run",
    "build_runner",
    "build",
    "--delete-conflicting-outputs",
  ]);
}

String replaceDomainKey(String? writeDir, String domain) {
  String result = writeDir ?? "";
  if (result.isNotEmpty) {
    result = result
        .replaceAll('{{DOMAIN}}', domain.snakeCase)
        .replaceAll('{{domain}}', domain.snakeCase)
        .replaceAll('{{Domain}}', domain.pascalCase);
  }
  return result;
}

/// Extracts and formats the parameters for calling an API method within a BLoC event handler.
///
/// It parses the method's parameters and returns a string of formatted arguments
/// (e.g., `id, name: event.name`) to be used in the generated code.
String getEventCallArgs(String? fpath, String? method) {
  if (fpath == null || method == null) return '';

  String? paramsJson;
  try {
    paramsJson = extractMethodParams(fpath, method);
    // printInfo(paramsJson);
  } catch (e) {
    // printWarning(e);
    // paramsJson = extractMethodInvocationArgs(fpath, method);
    // printInfo(paramsJson);
  }
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

Future<String> stateParam(String? fp, String? method, bool? isApiPath) async {
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

String eventParam(String? fp, String method, bool? isApiPath) {
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

String? newSourCode(ConstructorManager stateManager, String newFactory) {
  final result = stateManager.findOrReplace(replacementText: newFactory);
  final taskResult =
      result.otherProps["findOrReplace_result"] as Map<String, dynamic>?;
  final newSource = taskResult?["newSourceCode"] as String?;
  return newSource;
}
