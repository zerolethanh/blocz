//
//  Generated code. Do not modify.
//  source: user.proto
//

import "package:connectrpc/connect.dart" as connect;
import "user.pb.dart" as user;

/// UserService handles user-related operations such as retrieving and updating user profiles.
abstract final class UserService {
  /// Fully-qualified name of the UserService service.
  static const name = 'user.UserService';

  /// GetUser retrieves a user by their ID.
  static const getUser = connect.Spec(
    '/$name/GetUser',
    connect.StreamType.unary,
    user.GetUserRequest.new,
    user.GetUserResponse.new,
  );

  /// UpdateUser updates an existing user profile.
  static const updateUser = connect.Spec(
    '/$name/UpdateUser',
    connect.StreamType.unary,
    user.UpdateUserRequest.new,
    user.UpdateUserResponse.new,
  );

  /// SaveUser saves or updates a user profile.
  static const saveUser = connect.Spec(
    '/$name/SaveUser',
    connect.StreamType.unary,
    user.SaveUserRequest.new,
    user.SaveUserResponse.new,
  );

  /// UploadAvatar uploads a new profile photo for a user.
  static const uploadAvatar = connect.Spec(
    '/$name/UploadAvatar',
    connect.StreamType.unary,
    user.UploadAvatarRequest.new,
    user.UploadAvatarResponse.new,
  );

  /// UpdatePhotoUrl updates the profile photo URL for a user.
  static const updatePhotoUrl = connect.Spec(
    '/$name/UpdatePhotoUrl',
    connect.StreamType.unary,
    user.UpdatePhotoUrlRequest.new,
    user.UpdatePhotoUrlResponse.new,
  );
}
