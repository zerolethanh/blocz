import 'dart:core';

import 'package:blocz/extractMethodResponseTypeWithField.dart';
import 'package:blocz/extractProtoInfo.dart';

/// Extracts the type of the 'data' field from a method's response type.
Future<Map<String, dynamic>> extractMethodResponseInnerDataType(
  String filePath,
  String methodName,
) async {
  if (filePath.endsWith('.proto')) {
    final responseType = extractProtoMethodResponseType(filePath, methodName);
    return {
      "responseDataType": responseType,
      "hitField": "", // Proto responses don't usually have a 'data' field like openapi
    };
  }
  return await extractMethodResponseTypeWithField(
    filePath,
    methodName,
    "data,body",
  );
}
