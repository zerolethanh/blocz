import 'dart:io';

import 'package:path/path.dart' as p;

String? getProjectRootPath({String? scriptPath}) {
  String scriptDir = "";
  String currentWorkingDirectory = Directory.current.path;

  if (scriptPath == null) {
    //current directory
    scriptDir = currentWorkingDirectory;
  } else {
    final scriptPath0 = scriptPath;
    scriptDir = p.dirname(scriptPath0);
  }
  final root = _findProjectRoot(Directory(scriptDir));
  return root?.path;
}

Directory? _findProjectRoot(Directory startDir) {
  Directory current = startDir;
  while (true) {
    if (File(p.join(current.path, 'pubspec.yaml')).existsSync()) {
      return current;
    }
    // Break loop if we are at the root
    if (current.path == current.parent.path) return null;
    current = current.parent;
  }
}
