import 'package:blocz_example/api/example_api.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

part 'user_event.dart';
part 'user_state.dart';
part 'user_bloc.freezed.dart';

@lazySingleton
class UserBloc extends Bloc<UserEvent, UserState> {
  // dependencies injections
  // final OtherBloc _otherBloc = GetIt.I<OtherBloc>();
  // final OtherUseCase _otherUseCase;

  UserBloc(
    // this._otherUseCase
  ) : super(const UserState.initial()) {
    on<_UserEventLoading>(_onUserEventLoading);
    on<_GetUserByIdRequested>(_onGetUserByIdRequested);
    on<_GetUsersRequested>(_onGetUsersRequested);
    on<_CreateUserRequested>(_onCreateUserRequested);
    on<_DeleteUserRequested>(_onDeleteUserRequested);
    on<_GetUserByIdWithApiKeyRequested>(_onGetUserByIdWithApiKeyRequested);
    on<_UpdateUserRequested>(_onUpdateUserRequested);
  }

  Future<void> _onUserEventLoading(
    _UserEventLoading event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserState.loading());
  }

  Future<void> _onGetUserByIdRequested(
    _GetUserByIdRequested event,
    Emitter<UserState> emit,
  ) async {
    try {
      final exampleApi = GetIt.instance<ExampleApi>();
      final response = await exampleApi.getUserById(event.id);
      emit(UserState.getUserByIdResult(response));
    } catch (e) {
      emit(UserState.failure(e.toString()));
    }
  }

  Future<void> _onGetUsersRequested(
    _GetUsersRequested event,
    Emitter<UserState> emit,
  ) async {
    try {
      final exampleApi = GetIt.instance<ExampleApi>();
      final response = await exampleApi.getUsers();
      emit(UserState.getUsersResult(response));
    } catch (e) {
      emit(UserState.failure(e.toString()));
    }
  }

  Future<void> _onCreateUserRequested(
    _CreateUserRequested event,
    Emitter<UserState> emit,
  ) async {
    try {
      final exampleApi = GetIt.instance<ExampleApi>();
      final response = await exampleApi.createUser(event.user);
      emit(UserState.createUserResult(response));
    } catch (e) {
      emit(UserState.failure(e.toString()));
    }
  }

  Future<void> _onDeleteUserRequested(
    _DeleteUserRequested event,
    Emitter<UserState> emit,
  ) async {
    try {
      final exampleApi = GetIt.instance<ExampleApi>();
      final response = await exampleApi.deleteUser(event.id);
      emit(UserState.deleteUserResult(response));
    } catch (e) {
      emit(UserState.failure(e.toString()));
    }
  }

  Future<void> _onGetUserByIdWithApiKeyRequested(
    _GetUserByIdWithApiKeyRequested event,
    Emitter<UserState> emit,
  ) async {
    try {
      final exampleApi = GetIt.instance<ExampleApi>();
      final response = await exampleApi.getUserByIdWithApiKey(
        event.id,
        event.apiKey,
      );
      emit(UserState.getUserByIdWithApiKeyResult(response));
    } catch (e) {
      emit(UserState.failure(e.toString()));
    }
  }

  Future<void> _onUpdateUserRequested(
    _UpdateUserRequested event,
    Emitter<UserState> emit,
  ) async {
    try {
      final exampleApi = GetIt.instance<ExampleApi>();
      final response = await exampleApi.updateUser(event.user);
      emit(UserState.updateUserResult(response));
    } catch (e) {
      emit(UserState.failure(e.toString()));
    }
  }
}
