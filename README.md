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

Use the `make:bloc` command to generate the necessary components.

```bash
blocz make:bloc --domain <domain_name> --name <bloc_name>
```

- `--domain` (or `-d`): The domain or feature of the BLoC (e.g., `user`, `product`).
- `--name` (or `-n`): The name of the BLoC (e.g., `authentication`, `product_list`). This is an optional parameter.

**Example:**

```bash
blocz make:bloc --domain user --name login
```

This command will create the following directory structure and files:

```
lib/
└── features/
    └── user/
        └── presentation/
            └── bloc/
                ├── user_login_bloc.dart
                ├── user_login_event.dart
                └── user_login_state.dart
```

**Important:** Since the generated files use `freezed`, you need to run `build_runner` to generate the `.freezed.dart` and `.g.dart` files:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 2. Add an Event

Use the `add:event` command to add a new event to an existing BLoC.

```bash
blocz add:event --domain <domain_name> --name <bloc_name> --event <event_name>
```

**Example:**

```bash
blocz add:event --domain user --name login --event LogoutButtonPressed
```

This command will update the corresponding `_event.dart` and `_bloc.dart` files to add the `LogoutButtonPressed` event.

## Other Commands

`blocz` also provides many helper commands for parsing Dart source code. Use `blocz --help` to see all available commands.
