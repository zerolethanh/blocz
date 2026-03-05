import 'dart:convert';

typedef JSONString = String;

const String resultIdentifier = "---result---";

String _trimResultHeader(String value) {
  if (!value.contains(resultIdentifier)) {
    return value;
  }
  return value
      .split(resultIdentifier)
      .last
      .trim();
}

final class JSONStringResult with JSONStringMixin {
  dynamic data;
  Map<String, dynamic>? meta;

  JSONStringResult({required this.data, this.meta});

  factory JSONStringResult.parse(dynamic value) {
    Map<String, dynamic>? validJSON;
    if (value is Map<String, dynamic>) {
      validJSON = value;
    } else {
      try {
        if (value is String) {
          value = _trimResultHeader(value);
          validJSON = jsonDecode(value);
        }
      } catch (e) {
        validJSON = null;
      }
    }
    // print("$validData ${validData.runtimeType}");
    assert(validJSON is Map
        && validJSON!.containsKey("data"),
    "[JSONStringClass.parse]: input value should be Map<String, dynamic> or Json String, contains 'data' field."
    );
    return JSONStringResult(data: validJSON!['data'], meta: validJSON['meta']);
  }


  JSONString toJSONString() {
    return toJSONStringResult(data, meta);
  }

  @override
  JSONString toString({LogMethods? method}) {
    return "$resultIdentifier\n"
        "${switch(method){
          .prettyPrint => prettyPrint(toJSONString()),
          .removeEmpty => removeEmpty(toJSONString()),
          .removeEmptyThenPrettyPrint =>
          prettyPrint(removeEmpty(toJSONString())),
      _ => toJSONString()
    }}";
  }

  JSONString expose({LogMethods? method = .prettyPrint}) {
    return exposeJSON(
        toJSONString(),
        method: method
    );
  }

  Map<String, dynamic>? dataAsMap() {
    if (data is Map) {
      return data;
    } else if (data is String) {
      try {
        data = jsonDecode(data);
        if (data is Map) {
          return data;
        }
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  List<T>? dataAsList<T>() {
    // print("$data ${data.runtimeType}");
    if (data is List) {
      return (data as List).cast<T>();
    } else if (data is Map) {
      if (data["data"]!.isNotEmpty
          && data["data"] is List
      ) {
        return (data['data'] as List).cast<T>();
      }
    }
    return null;
  }

// List<T>? dataAsListOfType<T>() {
//   if (data is List) {
//     return (data as List).cast<T>();
//   } else if (data is String) {
//     try {
//       data = jsonDecode(data);
//       if (data is List) {
//         return (data as List).cast<T>();
//       }
//     } catch (e) {
//       return null;
//     }
//   }
//   return null;
// }

}

JSONString toJSONStringResult(dynamic values, [dynamic meta]) {
  return jsonEncode({"data": values, "meta": meta});
}

mixin JSONStringMixin {

  JSONString removeEmpty(JSONString json) {
    json = _trimResultHeader(json);
    dynamic values = jsonDecode(json);

    dynamic _removeEmptyRecursive(dynamic data) {
      if (data is List) {
        data.removeWhere((element) {
          if (element == null) return true;
          if (element is String && element.isEmpty) return true;
          return false;
        });
        for (int i = 0; i < data.length; i++) {
          data[i] = _removeEmptyRecursive(data[i]);
        }
      } else if (data is Map) {
        data.removeWhere((key, value) {
          if (value == null) return true;
          if (value is String && value.isEmpty) return true;
          return false;
        });
        data.forEach((key, value) {
          data[key] = _removeEmptyRecursive(value);
        });
      }
      return data;
    }
    values = _removeEmptyRecursive(values);
    final j = jsonEncode(values);
    return j;
  }

  JSONString prettyPrint(JSONString jsonValue) {
    jsonValue = _trimResultHeader(jsonValue);
    final encoder = JsonEncoder.withIndent("  ");
    final prettyValue = encoder.convert(jsonDecode(jsonValue));
    return prettyValue;
  }

  String exposeJSON(JSONString jsonString,
      {LogMethods? method = .prettyPrint}) {
    JSONString j = jsonString;
    switch (method) {
      case .removeEmpty:
        j = removeEmpty(jsonString);
      case .prettyPrint:
        j = prettyPrint(jsonString);
      case .removeEmptyThenPrettyPrint:
        j = prettyPrint(removeEmpty(jsonString));
      case _:
    }
    print(j);
    return j;
  }
}


enum LogMethods {
  removeEmpty,
  removeEmptyThenPrettyPrint,
  prettyPrint,
}
