//
//  Generated code. Do not modify.
//  source: user.proto
//

import "package:connectrpc/connect.dart" as connect;
import "user.pb.dart" as user;
import "user.connect.spec.dart" as specs;

/// UserService handles user-related operations such as retrieving and updating user profiles.
extension type UserServiceClient (connect.Transport _transport) {
  /// GetUser retrieves a user by their ID.
  Future<user.GetUserResponse> getUser(
    user.GetUserRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.UserService.getUser,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// UpdateUser updates an existing user profile.
  Future<user.UpdateUserResponse> updateUser(
    user.UpdateUserRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.UserService.updateUser,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// SaveUser saves or updates a user profile.
  Future<user.SaveUserResponse> saveUser(
    user.SaveUserRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.UserService.saveUser,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// UploadAvatar uploads a new profile photo for a user.
  Future<user.UploadAvatarResponse> uploadAvatar(
    user.UploadAvatarRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.UserService.uploadAvatar,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// UpdatePhotoUrl updates the profile photo URL for a user.
  Future<user.UpdatePhotoUrlResponse> updatePhotoUrl(
    user.UpdatePhotoUrlRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.UserService.updatePhotoUrl,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
