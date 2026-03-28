import 'package:blocz_example/gen/user.connect.client.dart';
import 'package:blocz_example/gen/user.pb.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectrpc/http2.dart';
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'user_proto_event.dart';
part 'user_proto_state.dart';
part 'user_proto_bloc.freezed.dart';

final userServiceClient = UserServiceClient(
  Transport(
    baseUrl: "https://[IP_ADDRESS]",
    codec: const ProtoCodec(), // Or JsonCodec()
    httpClient: createHttpClient(), // h2 transporter
  ),
);

@lazySingleton
class UserProtoBloc extends Bloc<UserProtoEvent, UserProtoState> {
  // dependencies injections
  // final OtherBloc _otherBloc = GetIt.I<OtherBloc>();
  // final OtherUseCase _otherUseCase;

  UserProtoBloc(
    // this._otherUseCase
  ) : super(const UserProtoState.initial()) {
    on<_GetUserRequested>(_onGetUserRequested);
    on<_UserProtoEventLoading>(_onUserProtoEventLoading);
    on<_UpdateUserRequested>(_onUpdateUserRequested);
    on<_SaveUserRequested>(_onSaveUserRequested);
    on<_UploadAvatarRequested>(_onUploadAvatarRequested);
    on<_UpdatePhotoUrlRequested>(_onUpdatePhotoUrlRequested);
  }

  Future<void> _onUserProtoEventLoading(
    _UserProtoEventLoading event,
    Emitter<UserProtoState> emit,
  ) async {
    emit(const UserProtoState.loading());
  }

  Future<void> _onGetUserRequested(
    _GetUserRequested event,
    Emitter<UserProtoState> emit,
  ) async {
    try {
      // emit(const UserProtoState.loading());
      final response = await userServiceClient.getUser(event.request);

      emit(UserProtoState.getUserResult(response));
    } catch (e) {
      emit(UserProtoState.failure(e.toString()));
    }
  }

  Future<void> _onUpdateUserRequested(
    _UpdateUserRequested event,
    Emitter<UserProtoState> emit,
  ) async {
    try {
      // emit(const UserProtoState.loading());
      final response = await userServiceClient.updateUser(event.request);

      emit(UserProtoState.updateUserResult(response));
    } catch (e) {
      emit(UserProtoState.failure(e.toString()));
    }
  }

  Future<void> _onSaveUserRequested(
    _SaveUserRequested event,
    Emitter<UserProtoState> emit,
  ) async {
    try {
      // emit(const UserProtoState.loading());
      final response = await userServiceClient.saveUser(event.request);

      emit(UserProtoState.saveUserResult(response));
    } catch (e) {
      emit(UserProtoState.failure(e.toString()));
    }
  }

  Future<void> _onUploadAvatarRequested(
    _UploadAvatarRequested event,
    Emitter<UserProtoState> emit,
  ) async {
    try {
      // emit(const UserProtoState.loading());
      final response = await userServiceClient.uploadAvatar(event.request);

      emit(UserProtoState.uploadAvatarResult(response));
    } catch (e) {
      emit(UserProtoState.failure(e.toString()));
    }
  }

  Future<void> _onUpdatePhotoUrlRequested(
    _UpdatePhotoUrlRequested event,
    Emitter<UserProtoState> emit,
  ) async {
    try {
      // emit(const UserProtoState.loading());
      final response = await userServiceClient.updatePhotoUrl(event.request);

      emit(UserProtoState.updatePhotoUrlResult(response));
    } catch (e) {
      emit(UserProtoState.failure(e.toString()));
    }
  }
}
