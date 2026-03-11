part of 'user_bloc.dart';

@freezed
sealed class UserEvent with _$UserEvent {
  const factory UserEvent.loading() = _UserEventLoading;
  const factory UserEvent.getUserById(int id) = _GetUserByIdRequested;
  const factory UserEvent.getUsers() = _GetUsersRequested;
  const factory UserEvent.createUser(User user) = _CreateUserRequested;
  const factory UserEvent.deleteUser(int id) = _DeleteUserRequested;
  const factory UserEvent.getUserByIdWithApiKey(int id, String apiKey) = _GetUserByIdWithApiKeyRequested;
  const factory UserEvent.updateUser(User user) = _UpdateUserRequested;
}
