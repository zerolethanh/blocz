// This is a generated file - do not edit.
//
// Generated from user.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'user.pb.dart' as $0;
import 'user.pbjson.dart';

export 'user.pb.dart';

abstract class UserServiceBase extends $pb.GeneratedService {
  $async.Future<$0.GetUserResponse> getUser(
      $pb.ServerContext ctx, $0.GetUserRequest request);
  $async.Future<$0.UpdateUserResponse> updateUser(
      $pb.ServerContext ctx, $0.UpdateUserRequest request);
  $async.Future<$0.SaveUserResponse> saveUser(
      $pb.ServerContext ctx, $0.SaveUserRequest request);
  $async.Future<$0.UploadAvatarResponse> uploadAvatar(
      $pb.ServerContext ctx, $0.UploadAvatarRequest request);
  $async.Future<$0.UpdatePhotoUrlResponse> updatePhotoUrl(
      $pb.ServerContext ctx, $0.UpdatePhotoUrlRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetUser':
        return $0.GetUserRequest();
      case 'UpdateUser':
        return $0.UpdateUserRequest();
      case 'SaveUser':
        return $0.SaveUserRequest();
      case 'UploadAvatar':
        return $0.UploadAvatarRequest();
      case 'UpdatePhotoUrl':
        return $0.UpdatePhotoUrlRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetUser':
        return getUser(ctx, request as $0.GetUserRequest);
      case 'UpdateUser':
        return updateUser(ctx, request as $0.UpdateUserRequest);
      case 'SaveUser':
        return saveUser(ctx, request as $0.SaveUserRequest);
      case 'UploadAvatar':
        return uploadAvatar(ctx, request as $0.UploadAvatarRequest);
      case 'UpdatePhotoUrl':
        return updatePhotoUrl(ctx, request as $0.UpdatePhotoUrlRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => UserServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => UserServiceBase$messageJson;
}
