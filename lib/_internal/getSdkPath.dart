import 'dart:io';

import 'package:path/path.dart' as p;

String? getSdkPath() {
  // 1. Try FLUTTER_ROOT env variable
  final flutterRootEnv = Platform.environment['FLUTTER_ROOT'];
  if (flutterRootEnv != null && flutterRootEnv.isNotEmpty) {
    final sdkPath = p.join(flutterRootEnv, 'bin', 'cache', 'dart-sdk');
    if (Directory(sdkPath).existsSync() && File(p.join(sdkPath, 'version')).existsSync()) {
      return sdkPath;
    }
    print("-- _getSdkPath: FLUTTER_ROOT path is not a valid SDK.");
  }

  // 2. Try to find flutter on PATH by running `which` or `where`
  // print("-- _getSdkPath: Trying to find 'flutter' on system PATH.");
  try {
    final command = Platform.isWindows ? 'where' : 'which';
    final result = Process.runSync(command, ['flutter'], runInShell: true);
    if (result.exitCode == 0) {
      final flutterExecutablePath = (result.stdout as String).split('\n').first.trim();
      if (flutterExecutablePath.isNotEmpty) {
        final realFlutterPath = File(flutterExecutablePath).resolveSymbolicLinksSync();
        final flutterBinDir = p.dirname(realFlutterPath);
        final flutterRoot = p.dirname(flutterBinDir);
        final sdkPath = p.join(flutterRoot, 'bin', 'cache', 'dart-sdk');
        if (Directory(sdkPath).existsSync() &&
            File(p.join(sdkPath, 'version')).existsSync()) {
          return sdkPath;
        }
        print("-- _getSdkPath: Found flutter executable, but derived SDK path is not valid.");
      }
    } else {
      print("-- _getSdkPath: '$command flutter' failed with exit code ${result.exitCode}.");
    }
  } catch (e) {
    print("-- _getSdkPath: Error running '${Platform.isWindows ? 'where' : 'which'} dart': $e");
  }

  // 3. Fallback to executable's path (for dart run ... scenarios)
  final realExecutablePath = File(Platform.resolvedExecutable).resolveSymbolicLinksSync();

  final sdkPathFromExecutable = p.dirname(p.dirname(realExecutablePath));
  if (Directory(sdkPathFromExecutable).existsSync() && File(p.join(sdkPathFromExecutable, 'version')).existsSync()) {
    print("-- _getSdkPath: Found valid SDK from executable path.");
    return sdkPathFromExecutable;
  }
  return null;
}
