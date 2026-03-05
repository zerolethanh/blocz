import '../MethodManager.dart';

abstract class IMethodManager {
  String get filePath;

  String get identifier;

  static const String identifierFormat = "[className].[methodName?]";

  MethodManagerResultData ON_invocationFindByMethodName({
    String? replacementHandlerBody,
  });

  MethodManagerResultData ON_invocationListAllMethods();

  MethodManagerResultData ON_invocationLastLineNumber();

  MethodManagerResultData listAllMethods();

  // returnType get method returns type,
  // eg: Future<Response<String>>, returns `Future<Response<String>>`
  MethodManagerResultData returnType();

  // returnInnerType get method returns inner type,
  // eg: Future<Response<String>>, level=1 returns `Response<String>`, level=2 returns `String`
  MethodManagerResultData returnInnerType([int innerLevel = 1]);

  // returnInnerPropType get method returns inner prop type,
  // eg: Future<Response<User>> -> User.id, returns `String`
  MethodManagerResultData returnInnerPropType(
    String propName, [
    int innerLevel = 1,
    // String? backOffLibraryUri = "package:http/src/response.dart"
  ]);

  // returnInnerBodyType get method returns inner body type,
  //
  Future<MethodManagerResultData> returnInnerTypeOfHttpResponse({
    String propName = "body",
    String? libraryUri = "package:http/src/response.dart",
    String? libraryClassName = "Response",
    int innerLevel = 1,
  });

  // paramsList
  // returns params list of method
  MethodManagerResultData paramsList();

  // info
  // all info about method
  MethodManagerResultData info();
}