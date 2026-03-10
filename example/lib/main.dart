import 'dart:async';
import 'features/user/presentation/bloc/user_bloc.dart';
import 'injection.dart';

void main() async {
  // Initialize dependency injection
  configureDependencies();

  final userBloc = getIt<UserBloc>();

  print('--- Blocz Example CLI ---');

  // Listen to state changes
  final subscription = userBloc.stream.listen((state) {
    state.when(
      initial: () => print('[State] Initial'),
      loading: () => print('[State] Loading...'),
      failure: (message) => print('[State] Failure: $message'),
      getUserByIdResult: (user) =>
          print('[State] Success: Found user ${user.name}'),
      getUsersResult: (users) =>
          print('[State] Success: Fetched ${users.length} users'),
      createUserResult: () => print('[State] Success: User created'),
      deleteUserResult: () => print('[State] Success: User deleted'),
    );
  });

  // Dispatch events
  print('\n[Action] Fetching all users...');
  userBloc.add(const UserEvent.getUsers());

  await Future.delayed(const Duration(milliseconds: 500));

  print('\n[Action] Fetching user by ID (1)...');
  userBloc.add(const UserEvent.getUserById(1));

  await Future.delayed(const Duration(milliseconds: 500));

  // Cleanup
  await subscription.cancel();
  await userBloc.close();
  print('\n--- Example Finished ---');
}
