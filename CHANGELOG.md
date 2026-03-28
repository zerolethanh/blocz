## 1.5.0

- **Protobuf Support**: You can now generate BLoC events and states directly from `.proto` files. Use `blocz add:event -d <domain> -a <proto_file> --update` to automatically extract RPC methods and generate the corresponding BLoC logic.
- **Repository Scaffolding**: Added support for generating repository interfaces and implementations. Use the `--repository` (or `-r`) flag with `add:event` to create a clean repository layer skeleton synced with your API/Proto methods.
- **Enhanced Code Generation**: Improved support for ConnectRPC and Protobuf through automatic import injection and client instance generation.

## 1.4.0

- **New `--update` flag**: Added support for updating existing events. When used, `blocz` will synchronize parameters between your API methods and existing Event/State factory constructors, and surgically update BLoC method call arguments.
- **Robust Parameter Extraction**: Uses Dart AST (Abstract Syntax Tree) to correctly parse complex method arguments (e.g., nested parentheses) during code generation.
- **Surgical BLoC Updates**: Implemented AST-based surgical updates that only modify the necessary method call arguments, preserving any manual logic added to BLoC handlers.
- **Improved Documentation**: Added Mermaid flow diagrams to README and README-vi to explain `make` and `add:event` workflows.
- **Enhanced READMEs**: Clearly highlighted the technical advantages of using AST for reliable and non-destructive scaffolding.
- **Bug Fixes**: Resolved issues with fragile regex-based extraction and improved general stability.

## 1.3.0

- Added documentation for "Import from API" feature in READMEs.
- Improved CLI help messages and command descriptions.
- Minor bug fixes and technical descriptions enhancements.

## 1.2.1

- auto run `dart format` and `dart run build_runner build --delete-conflicting-outputs` after generation

## 1.2.0

- simplicit

## 1.1.0

- update: now you can use --apiPath by `make:bloc` command to import from an api path. Details at readme
- fix: performance

## 1.0.0

- Initial version.
