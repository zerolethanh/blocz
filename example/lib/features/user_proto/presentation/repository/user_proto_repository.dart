import 'package:blocz_example/gen/user.pb.dart';

abstract class UserProtoRepository {
  Future<GetUserResponse> getUser(GetUserRequest request);
  Future<UpdateUserResponse> updateUser(UpdateUserRequest request);
  Future<SaveUserResponse> saveUser(SaveUserRequest request);
  Future<UploadAvatarResponse> uploadAvatar(UploadAvatarRequest request);
  Future<UpdatePhotoUrlResponse> updatePhotoUrl(UpdatePhotoUrlRequest request);
}
