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
      final api = GetIt.instance<ExampleApi>();
      final response = await api.getUserById(event.id);
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
      final api = GetIt.instance<ExampleApi>();
      final response = await api.getUsers();
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
      final api = GetIt.instance<ExampleApi>();
      await api.createUser(event.user);
      emit(UserState.createUserResult());
    } catch (e) {
      emit(UserState.failure(e.toString()));
    }
  }

  Future<void> _onDeleteUserRequested(
    _DeleteUserRequested event,
    Emitter<UserState> emit,
  ) async {
    try {
      final api = GetIt.instance<ExampleApi>();
      await api.deleteUser(event.id);
      emit(UserState.deleteUserResult());
    } catch (e) {
      emit(UserState.failure(e.toString()));
    }
  }
}
