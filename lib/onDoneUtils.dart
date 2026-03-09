import 'dart:io';

import 'package:blocz/_internal/colors.dart';

void runDartFormat(String dir) {
  printInfo("running dart format for $dir");
  // run format
  Process.runSync("dart", ["run", "format", dir]);
}

void runBuildRunner(String dir) {
  printInfo("running build_runner");
  // run build_runner
  Process.runSync("dart", [
    "run",
    "build_runner",
    "build",
    "--delete-conflicting-outputs",
  ]);
}
