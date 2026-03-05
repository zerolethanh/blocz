import '../ClassManager.dart';

abstract class IClassManager {
  String get filePath;

  String get identifier;

  String? get className;

  static const String identifierFormat = "[className]";

  ClassManagerResultData get dataSingleton;

  ClassManagerResultData listAllMethods();

  ClassManagerResultData listAllConstructors();

  ClassManagerResultData listAllGetters();

  ClassManagerResultData listAllSetters();

  ClassManagerResultData lastLineNumberGet();

  ClassManagerResultData lastConstFactoryLineNumber();
}
