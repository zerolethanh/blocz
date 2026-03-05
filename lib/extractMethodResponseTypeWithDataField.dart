import 'dart:core';

import 'package:floc_helper/extractMethodResponseTypeWithField.dart';

/// Extracts the type of the 'data' field from a method's response type.
Future<Map<String, dynamic>> extractMethodResponseInnerDataType(String filePath,
    String methodName) async {
  return await extractMethodResponseTypeWithField(
      filePath, methodName, "data,body");
}
