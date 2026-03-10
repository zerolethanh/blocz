import '../ConstructorManager.dart';

abstract class IConstructorManager {
  String get filePath;

  String get identifier;

  static const String identifierFormat = "[className].[constructorName?]";

  ConstructorManagerResultData findOrReplace({String? replacementText});

  ConstructorManagerResultData listAllConstructors();

  ConstructorManagerResultData listAllConstructorsIgnoreIdentifier();

  bool hasFactoryConstructor();
}
