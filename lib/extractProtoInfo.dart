import 'dart:io';

class ProtoMethod {
  final String name;
  final String requestType;
  final String responseType;
  final bool isClientStreaming;
  final bool isServerStreaming;

  ProtoMethod({
    required this.name,
    required this.requestType,
    required this.responseType,
    this.isClientStreaming = false,
    this.isServerStreaming = false,
  });
}

class ProtoService {
  final String name;
  final List<ProtoMethod> methods;

  ProtoService({required this.name, required this.methods});
}

class ProtoMessageField {
  final String type;
  final String name;
  final bool isRepeated;

  ProtoMessageField({
    required this.type,
    required this.name,
    this.isRepeated = false,
  });
}

class ProtoMessage {
  final String name;
  final List<ProtoMessageField> fields;

  ProtoMessage({required this.name, required this.fields});
}

List<ProtoService> parseProtoServices(String content) {
  final services = <ProtoService>[];
  final serviceRegex = RegExp(r'service\s+(\w+)\s*\{([\s\S]*?)\}');
  final rpcRegex = RegExp(
    r'rpc\s+(\w+)\s*\(\s*(stream\s+)?(\w+)?\s*\)\s*returns\s*\(\s*(stream\s+)?(\w+)?\s*\)\s*;',
  );

  for (final serviceMatch in serviceRegex.allMatches(content)) {
    final serviceName = serviceMatch.group(1)!;
    final serviceBody = serviceMatch.group(2)!;
    final methods = <ProtoMethod>[];

    for (final rpcMatch in rpcRegex.allMatches(serviceBody)) {
      methods.add(
        ProtoMethod(
          name: rpcMatch.group(1)!,
          isClientStreaming: rpcMatch.group(2) != null,
          requestType: rpcMatch.group(3) ?? 'void',
          isServerStreaming: rpcMatch.group(4) != null,
          responseType: rpcMatch.group(5) ?? 'void',
        ),
      );
    }
    services.add(ProtoService(name: serviceName, methods: methods));
  }
  return services;
}

List<ProtoMessage> parseProtoMessages(String content) {
  final messages = <ProtoMessage>[];
  final messageRegex = RegExp(r'message\s+(\w+)\s*\{([\s\S]*?)\}');
  final fieldRegex = RegExp(
    r'^\s*(repeated\s+)?([\w\.]+)\s+(\w+)\s*=\s*\d+\s*;',
    multiLine: true,
  );

  for (final messageMatch in messageRegex.allMatches(content)) {
    final messageName = messageMatch.group(1)!;
    final messageBody = messageMatch.group(2)!;
    final fields = <ProtoMessageField>[];

    for (final fieldMatch in fieldRegex.allMatches(messageBody)) {
      fields.add(
        ProtoMessageField(
          isRepeated: fieldMatch.group(1) != null,
          type: fieldMatch.group(2)!,
          name: fieldMatch.group(3)!,
        ),
      );
    }
    messages.add(ProtoMessage(name: messageName, fields: fields));
  }
  return messages;
}

String mapProtoTypeToDart(String protoType) {
  switch (protoType) {
    case 'string':
      return 'String';
    case 'int32':
    case 'uint32':
    case 'int64':
    case 'uint64':
    case 'sint32':
    case 'sint64':
    case 'fixed32':
    case 'fixed64':
    case 'sfixed32':
    case 'sfixed64':
      return 'int';
    case 'double':
    case 'float':
      return 'double';
    case 'bool':
      return 'bool';
    case 'bytes':
      return 'List<int>';
    case 'google.protobuf.Timestamp':
      return 'DateTime';
    default:
      // Handle qualified types like google.type.Money
      if (protoType.contains('.')) {
        return protoType.split('.').last;
      }
      return protoType;
  }
}

List<String> extractMethodListFromProto(String filePath) {
  final content = File(filePath).readAsStringSync();
  final services = parseProtoServices(content);
  return services.expand((s) => s.methods.map((m) => m.name)).toList();
}

String extractProtoMethodParams(String filePath, String methodName) {
  final content = File(filePath).readAsStringSync();
  final services = parseProtoServices(content);

  for (final service in services) {
    for (final method in service.methods) {
      if (method.name == methodName) {
        final requestType = method.requestType;
        if (requestType == 'void' || requestType == 'google.protobuf.Empty') {
          return '()';
        }

        final type = method.isClientStreaming
            ? 'Stream<$requestType>'
            : requestType;
        return '($type request)';
      }
    }
  }
  return '()';
}

String extractProtoMethodResponseType(String filePath, String methodName) {
  final content = File(filePath).readAsStringSync();
  final services = parseProtoServices(content);

  for (final service in services) {
    for (final method in service.methods) {
      if (method.name == methodName) {
        final responseType = method.responseType;
        if (responseType == 'void' || responseType == 'google.protobuf.Empty') {
          return 'void';
        }
        return method.isServerStreaming
            ? 'Stream<$responseType>'
            : responseType;
      }
    }
  }
  return 'dynamic';
}

String getProtoServiceName(String filePath, String methodName) {
  final content = File(filePath).readAsStringSync();
  final services = parseProtoServices(content);

  for (final service in services) {
    for (final method in service.methods) {
      if (method.name == methodName) {
        return service.name;
      }
    }
  }
  return 'Service';
}

String getProtoClassName(String filePath, String methodName) {
  final content = File(filePath).readAsStringSync();
  final services = parseProtoServices(content);

  for (final service in services) {
    for (final method in service.methods) {
      if (method.name == methodName) {
        return '${service.name}Client';
      }
    }
  }
  return 'Client';
}
