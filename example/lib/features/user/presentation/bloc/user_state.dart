part of 'user_bloc.dart';

@freezed
sealed class UserState with _$UserState {
  const factory UserState.initial() = _InitialDone;
  const factory UserState.loading() = _Loading;
  const factory UserState.failure(String message) = _Failure;
  const factory UserState.getUserByIdResult(User data) = _GetUserByIdResult;
  const factory UserState.getUsersResult(List<User> data) = _GetUsersResult;
  const factory UserState.createUserResult() = _CreateUserResult;
  const factory UserState.deleteUserResult() = _DeleteUserResult;
}
