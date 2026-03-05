import "package:dcli/dcli.dart";

String writeFilePath = "last_build_hash.txt";
String binaryFilePath = 'floc_helper';

void main() {
  String hash = calculateHash(binaryFilePath).toString();

  if (!exists(writeFilePath)) {
    touch(writeFilePath, create: true);
    // sleep(1);
  }
  String? lastbuiltHash = read(writeFilePath).firstLine;
  echo(green("current hash: $lastbuiltHash"), newline: true);
  echo(green("new hash:     $hash"), newline: true);

  bool changed = false;
  if (hash != lastbuiltHash) {
    writeFilePath.write(hash);
    changed = true;
  }

  if (changed) {
    print("changed");
  } else {
    print("no-changes");
  }
}
