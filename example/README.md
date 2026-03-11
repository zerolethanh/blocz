# Blocz Example

This is a simple example showing how to use `blocz` to generate BLoC components from an API service.

## Setup

First, make sure you have `blocz` installed:

```bash
dart pub global activate --source path ..
```

## Running Blocz

To generate a BLoC for the `User` domain using the `ExampleApi`:

```bash
blocz make --domain user --apiPath lib/api/example_api.dart
```

This project demonstrates how `blocz` can be used to scaffold a feature with BLoC, events, and states, and how it can automatically integrate with an API layer.

This will create:

- `lib/features/user/presentation/bloc/user_bloc.dart`
- `lib/features/user/presentation/bloc/user_event.dart`
- `lib/features/user/presentation/bloc/user_state.dart`

With events and handlers automatically generated for `getUserById`, `getUsers`, `createUser`, and `deleteUser`.

## Generation Flow

### 1. BLoC Scaffolding (`make`)

```mermaid
graph TD
    Start([make]) --> Exist{Files exist?}
    Exist -- No --> Gen[Generate from templates]
    Exist -- Yes --> API{apiPath?}
    Gen --> API
    API -- Yes --> Add[Add Events]
    API -- No --> End[Build & Format]
    Add --> End
```

### 2. Adding Events (`add:event`)

```mermaid
graph TD
    Start([add:event]) --> Mode{apiPath?}
    Mode -- Yes --> Bulk[Bulk process]
    Mode -- No --> Single[Single event]
    Bulk --> Single
    
    subgraph Flow [Event Update]
        Files[Ensure files exist]
        Files --> Ev[Update Event]
        Ev --> St[Update State]
        St --> Bl[Update BLoC Handler]
    end
    
    Single --> Flow
    Flow --> End[Build & Format]
```

## Testing

Run `dart run build_runner build --delete-conflicting-outputs` if needed.

```bash
dart run lib/main.dart
```
