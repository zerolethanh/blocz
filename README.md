# blocz

A command-line interface (CLI) tool to speed up Flutter app development by scaffolding BLoC pattern components.

[![pub version](https://img.shields.io/pub/v/blocz.svg)](https://pub.dev/packages/blocz)

## About

`blocz` helps you quickly generate BLoC, Event, and State files in a structured directory, saving you time and keeping your codebase consistent. The tool also supports adding events to an existing BLoC.

## Features

- Generate BLoC, Event, and State with a single command.
- Automatically create a domain-based directory structure.
- The generated code is compatible with popular packages like `flutter_bloc`, `freezed`, and `injectable`.
- Supports quickly adding new events to a BLoC.

## Prerequisites

Your Flutter project must have the following dependencies in your `pubspec.yaml`:

```yaml
dependencies:
  flutter_bloc: <version>
  freezed_annotation: <version>
  injectable: <version>

dev_dependencies:
  build_runner: <version>
  freezed: <version>
  injectable_generator: <version>
```

## Installation

Activate `blocz` as a global tool to use it from anywhere:

```bash
dart pub global activate blocz
```

## Usage

### 1. Create BLoC, Event, and State

Use the `make` command to generate the necessary components.

```bash
blocz make --domain <domain_name> --name <bloc_name> [--apiPath <path_to_api_file>]
```

- `--domain` (or `-d`): The domain or feature of the BLoC (e.g., `user`, `product`).
- `--name` (or `-n`)(optional): The name of the BLoC (e.g., `authentication`, `product_list`).
- `--apiPath` (or `-a`)(optional): Optional path to an API service file. If provided, `blocz` will automatically generate and implement events for all public methods in that file.

**Examples:**

Basic BLoC creation:

```bash
blocz make --domain user
```

This command creates the BLoC structure. You will then need to run `build_runner`.

BLoC creation with automatic event implementation from an API file:

#### Example with OpenAPI generator:

```bash
export MY_PET_API_PACKAGE_NAME="my_pet_api"
export MY_PET_API_DIR="./apis/$MY_PET_API_PACKAGE_NAME"
rm -fr $MY_PET_API_DIR || true # remove old
mkdir -p $MY_PET_API_DIR # create if not exists
npx @openapitools/openapi-generator-cli generate \
  -i https://petstore.swagger.io/v2/swagger.json \
  -g dart \
  --additional-properties=pubName=$MY_PET_API_PACKAGE_NAME \
  -o $MY_PET_API_DIR
cd $MY_PET_API_DIR \
  && dart pub get \
  && (dart run build_runner build || true) \
  && cd "$(git rev-parse --show-toplevel)"
```

```yaml
# in your pubspec.yaml
dependencies:
  my_pet_api: # Added local API package
    path: ./apis/my_pet_api
```

```bash
blocz make --domain pet --apiPath /Users/lethanh/StudioProjects/eliza/apis/my_pet_api/lib/api/pet_api.dart
```

This command will create the BLoC files and also automatically add events and handlers for all methods found in `user_api.dart`.

**Important:** Since the generated files use `freezed`, you need to run `build_runner` after generation:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 2. Add an Event

Use the `add:event` command to add a new event to an existing BLoC.

```bash
blocz add:event --domain <domain_name> --name <bloc_name> <options>
```

**Options:**

- `--event <event_name>`: Adds a single, specified event.
- `--apiPath <path_to_api_file>`: Scans the API file and generates events and handlers for **all** public methods.
- `--apiPath <path_to_api_file> --method <method_name>`: Generates an event and handler for **only one** specified method from the API file.

**Examples:**

Add a simple event:

```bash
blocz add:event --domain user --name login --event LogoutButtonPressed
```

Add all events from an API file:

```bash
blocz add:event --domain user --name profile --apiPath ./packages/my_pet_api/lib/api/pet_api.dart
```

Add a single event from a specific API method:

```bash
blocz add:event --domain user --name profile --event UpdateAvatar --apiPath lib/features/user/data/api/user_api.dart --method uploadAvatar
```

This command will update the corresponding BLoC files to add the new event(s).

## Other Commands

`blocz` also provides many helper commands for parsing Dart source code. Use `blocz --help` to see all available commands.
