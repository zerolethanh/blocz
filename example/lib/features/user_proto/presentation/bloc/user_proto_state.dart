part of 'user_proto_bloc.dart';

@freezed
sealed class UserProtoState with _$UserProtoState {
  const factory UserProtoState.initial() = _InitialDone;
  const factory UserProtoState.loading() = _Loading;
  const factory UserProtoState.failure(String message) = _Failure;
  const factory UserProtoState.getUserResult(GetUserResponse data) = _GetUserResult;
  const factory UserProtoState.updateUserResult(UpdateUserResponse data) = _UpdateUserResult;
  const factory UserProtoState.saveUserResult(SaveUserResponse data) = _SaveUserResult;
  const factory UserProtoState.uploadAvatarResult(UploadAvatarResponse data) = _UploadAvatarResult;
  const factory UserProtoState.updatePhotoUrlResult(UpdatePhotoUrlResponse data) = _UpdatePhotoUrlResult;
}
