// Define ANSI color codes
const String esc = '\x1B';
const String red = '$esc[31m';
const String green = '$esc[32m';
const String yellow = '$esc[33m';
const String blue = '$esc[34m';
const String reset = '$esc[0m'; // Reset to default color/style

void printInfo(dynamic values) {
  print("$blue$values$reset");
}

void printSuccess(dynamic values) {
  print("$green$values$reset");
}

void printWarning(dynamic values) {
  print("$yellow$values$reset");
}

void printError(dynamic values) {
  print("$red$values$reset");
}