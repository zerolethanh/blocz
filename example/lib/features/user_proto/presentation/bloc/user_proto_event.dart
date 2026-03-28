part of 'user_proto_bloc.dart';

@freezed
sealed class UserProtoEvent with _$UserProtoEvent {
  const factory UserProtoEvent.loading() = _UserProtoEventLoading;
  const factory UserProtoEvent.getUser(GetUserRequest request) = _GetUserRequested;
  const factory UserProtoEvent.updateUser(UpdateUserRequest request) = _UpdateUserRequested;
  const factory UserProtoEvent.saveUser(SaveUserRequest request) = _SaveUserRequested;
  const factory UserProtoEvent.uploadAvatar(UploadAvatarRequest request) = _UploadAvatarRequested;
  const factory UserProtoEvent.updatePhotoUrl(UpdatePhotoUrlRequest request) = _UpdatePhotoUrlRequested;
}
