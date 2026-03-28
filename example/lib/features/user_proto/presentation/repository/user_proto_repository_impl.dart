import 'package:blocz_example/gen/user.pb.dart';
import 'package:injectable/injectable.dart';
import 'user_proto_repository.dart';

@LazySingleton(as: UserProtoRepository)
class UserProtoRepositoryImpl implements UserProtoRepository {
  @override
  Future<GetUserResponse> getUser(GetUserRequest request) async {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<UpdateUserResponse> updateUser(UpdateUserRequest request) async {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<SaveUserResponse> saveUser(SaveUserRequest request) async {
    // TODO: implement saveUser
    throw UnimplementedError();
  }

  @override
  Future<UploadAvatarResponse> uploadAvatar(UploadAvatarRequest request) async {
    // TODO: implement uploadAvatar
    throw UnimplementedError();
  }

  @override
  Future<UpdatePhotoUrlResponse> updatePhotoUrl(
    UpdatePhotoUrlRequest request,
  ) async {
    // TODO: implement updatePhotoUrl
    throw UnimplementedError();
  }
}
