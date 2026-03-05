import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:blocz/_internal/typedef.dart';
import 'package:blocz/_internal/visitChildren.dart';

JSONString getClassName(String codePath) {
  return getFirstClassNameInFile(codePath);
}

JSONString getFirstClassNameInFile(String codePath) {
  try {
    final f = JSONStringResult
        .parse(getClassNameListInFile(codePath))
        .dataAsList<String>()
        ?.first;
    return f ?? "";
  } catch (e) {
    return "";
  }
}

JSONString getClassNameListInFile(String codePath) {
  final visitor = _ClassNameListExtractor();
  visitChildren(codePath, visitor);
  return JSONStringResult(
      data: visitor.classNameList,
      meta: {
        "total": visitor.classNameList.length
      }
  ).toString();
}

// 4. Create a Visitor to find ClassDeclarations
class _ClassNameListExtractor extends GeneralizingAstVisitor<void> {
  List<String> classNameList = [];

  @override
  void visitClassDeclaration(ClassDeclaration cls) {
    classNameList.add(cls.namePart.typeName.toString());
  }
}
