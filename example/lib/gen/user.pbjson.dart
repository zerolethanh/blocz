// This is a generated file - do not edit.
//
// Generated from user.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use userDescriptor instead')
const User$json = {
  '1': 'User',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
    {'1': 'display_name', '3': 3, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'photo_url', '3': 4, '4': 1, '5': 9, '10': 'photoUrl'},
    {'1': 'last_login_at', '3': 5, '4': 1, '5': 3, '10': 'lastLoginAt'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode(
    'CgRVc2VyEg4KAmlkGAEgASgJUgJpZBIUCgVlbWFpbBgCIAEoCVIFZW1haWwSIQoMZGlzcGxheV'
    '9uYW1lGAMgASgJUgtkaXNwbGF5TmFtZRIbCglwaG90b191cmwYBCABKAlSCHBob3RvVXJsEiIK'
    'DWxhc3RfbG9naW5fYXQYBSABKANSC2xhc3RMb2dpbkF0');

@$core.Deprecated('Use getUserRequestDescriptor instead')
const GetUserRequest$json = {
  '1': 'GetUserRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserRequestDescriptor =
    $convert.base64Decode('Cg5HZXRVc2VyUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQ=');

@$core.Deprecated('Use getUserResponseDescriptor instead')
const GetUserResponse$json = {
  '1': 'GetUserResponse',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.user.User', '10': 'user'},
  ],
};

/// Descriptor for `GetUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRVc2VyUmVzcG9uc2USHgoEdXNlchgBIAEoCzIKLnVzZXIuVXNlclIEdXNlcg==');

@$core.Deprecated('Use updateUserRequestDescriptor instead')
const UpdateUserRequest$json = {
  '1': 'UpdateUserRequest',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.user.User', '10': 'user'},
  ],
};

/// Descriptor for `UpdateUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserRequestDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVVc2VyUmVxdWVzdBIeCgR1c2VyGAEgASgLMgoudXNlci5Vc2VyUgR1c2Vy');

@$core.Deprecated('Use updateUserResponseDescriptor instead')
const UpdateUserResponse$json = {
  '1': 'UpdateUserResponse',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.user.User', '10': 'user'},
  ],
};

/// Descriptor for `UpdateUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserResponseDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVVc2VyUmVzcG9uc2USHgoEdXNlchgBIAEoCzIKLnVzZXIuVXNlclIEdXNlcg==');

@$core.Deprecated('Use saveUserRequestDescriptor instead')
const SaveUserRequest$json = {
  '1': 'SaveUserRequest',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.user.User', '10': 'user'},
  ],
};

/// Descriptor for `SaveUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List saveUserRequestDescriptor = $convert.base64Decode(
    'Cg9TYXZlVXNlclJlcXVlc3QSHgoEdXNlchgBIAEoCzIKLnVzZXIuVXNlclIEdXNlcg==');

@$core.Deprecated('Use saveUserResponseDescriptor instead')
const SaveUserResponse$json = {
  '1': 'SaveUserResponse',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.user.User', '10': 'user'},
  ],
};

/// Descriptor for `SaveUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List saveUserResponseDescriptor = $convert.base64Decode(
    'ChBTYXZlVXNlclJlc3BvbnNlEh4KBHVzZXIYASABKAsyCi51c2VyLlVzZXJSBHVzZXI=');

@$core.Deprecated('Use uploadAvatarRequestDescriptor instead')
const UploadAvatarRequest$json = {
  '1': 'UploadAvatarRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
    {'1': 'filename', '3': 3, '4': 1, '5': 9, '10': 'filename'},
  ],
};

/// Descriptor for `UploadAvatarRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadAvatarRequestDescriptor = $convert.base64Decode(
    'ChNVcGxvYWRBdmF0YXJSZXF1ZXN0EhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBISCgRkYXRhGA'
    'IgASgMUgRkYXRhEhoKCGZpbGVuYW1lGAMgASgJUghmaWxlbmFtZQ==');

@$core.Deprecated('Use uploadAvatarResponseDescriptor instead')
const UploadAvatarResponse$json = {
  '1': 'UploadAvatarResponse',
  '2': [
    {'1': 'photo_url', '3': 1, '4': 1, '5': 9, '10': 'photoUrl'},
  ],
};

/// Descriptor for `UploadAvatarResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadAvatarResponseDescriptor =
    $convert.base64Decode(
        'ChRVcGxvYWRBdmF0YXJSZXNwb25zZRIbCglwaG90b191cmwYASABKAlSCHBob3RvVXJs');

@$core.Deprecated('Use updatePhotoUrlRequestDescriptor instead')
const UpdatePhotoUrlRequest$json = {
  '1': 'UpdatePhotoUrlRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'photo_url', '3': 2, '4': 1, '5': 9, '10': 'photoUrl'},
  ],
};

/// Descriptor for `UpdatePhotoUrlRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePhotoUrlRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVQaG90b1VybFJlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEhsKCXBob3'
    'RvX3VybBgCIAEoCVIIcGhvdG9Vcmw=');

@$core.Deprecated('Use updatePhotoUrlResponseDescriptor instead')
const UpdatePhotoUrlResponse$json = {
  '1': 'UpdatePhotoUrlResponse',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'photo_url', '3': 2, '4': 1, '5': 9, '10': 'photoUrl'},
  ],
};

/// Descriptor for `UpdatePhotoUrlResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePhotoUrlResponseDescriptor =
    $convert.base64Decode(
        'ChZVcGRhdGVQaG90b1VybFJlc3BvbnNlEhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIbCglwaG'
        '90b191cmwYAiABKAlSCHBob3RvVXJs');

const $core.Map<$core.String, $core.dynamic> UserServiceBase$json = {
  '1': 'UserService',
  '2': [
    {
      '1': 'GetUser',
      '2': '.user.GetUserRequest',
      '3': '.user.GetUserResponse',
      '4': {}
    },
    {
      '1': 'UpdateUser',
      '2': '.user.UpdateUserRequest',
      '3': '.user.UpdateUserResponse',
      '4': {}
    },
    {
      '1': 'SaveUser',
      '2': '.user.SaveUserRequest',
      '3': '.user.SaveUserResponse',
      '4': {}
    },
    {
      '1': 'UploadAvatar',
      '2': '.user.UploadAvatarRequest',
      '3': '.user.UploadAvatarResponse',
      '4': {}
    },
    {
      '1': 'UpdatePhotoUrl',
      '2': '.user.UpdatePhotoUrlRequest',
      '3': '.user.UpdatePhotoUrlResponse',
      '4': {}
    },
  ],
};

@$core.Deprecated('Use userServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    UserServiceBase$messageJson = {
  '.user.GetUserRequest': GetUserRequest$json,
  '.user.GetUserResponse': GetUserResponse$json,
  '.user.User': User$json,
  '.user.UpdateUserRequest': UpdateUserRequest$json,
  '.user.UpdateUserResponse': UpdateUserResponse$json,
  '.user.SaveUserRequest': SaveUserRequest$json,
  '.user.SaveUserResponse': SaveUserResponse$json,
  '.user.UploadAvatarRequest': UploadAvatarRequest$json,
  '.user.UploadAvatarResponse': UploadAvatarResponse$json,
  '.user.UpdatePhotoUrlRequest': UpdatePhotoUrlRequest$json,
  '.user.UpdatePhotoUrlResponse': UpdatePhotoUrlResponse$json,
};

/// Descriptor for `UserService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List userServiceDescriptor = $convert.base64Decode(
    'CgtVc2VyU2VydmljZRI4CgdHZXRVc2VyEhQudXNlci5HZXRVc2VyUmVxdWVzdBoVLnVzZXIuR2'
    'V0VXNlclJlc3BvbnNlIgASQQoKVXBkYXRlVXNlchIXLnVzZXIuVXBkYXRlVXNlclJlcXVlc3Qa'
    'GC51c2VyLlVwZGF0ZVVzZXJSZXNwb25zZSIAEjsKCFNhdmVVc2VyEhUudXNlci5TYXZlVXNlcl'
    'JlcXVlc3QaFi51c2VyLlNhdmVVc2VyUmVzcG9uc2UiABJHCgxVcGxvYWRBdmF0YXISGS51c2Vy'
    'LlVwbG9hZEF2YXRhclJlcXVlc3QaGi51c2VyLlVwbG9hZEF2YXRhclJlc3BvbnNlIgASTQoOVX'
    'BkYXRlUGhvdG9VcmwSGy51c2VyLlVwZGF0ZVBob3RvVXJsUmVxdWVzdBocLnVzZXIuVXBkYXRl'
    'UGhvdG9VcmxSZXNwb25zZSIA');
