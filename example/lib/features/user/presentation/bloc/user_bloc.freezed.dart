// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UserEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(int id) getUserById,
    required TResult Function() getUsers,
    required TResult Function(User user) createUser,
    required TResult Function(int id) deleteUser,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(int id)? getUserById,
    TResult? Function()? getUsers,
    TResult? Function(User user)? createUser,
    TResult? Function(int id)? deleteUser,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(int id)? getUserById,
    TResult Function()? getUsers,
    TResult Function(User user)? createUser,
    TResult Function(int id)? deleteUser,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_UserEventLoading value) loading,
    required TResult Function(_GetUserByIdRequested value) getUserById,
    required TResult Function(_GetUsersRequested value) getUsers,
    required TResult Function(_CreateUserRequested value) createUser,
    required TResult Function(_DeleteUserRequested value) deleteUser,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_UserEventLoading value)? loading,
    TResult? Function(_GetUserByIdRequested value)? getUserById,
    TResult? Function(_GetUsersRequested value)? getUsers,
    TResult? Function(_CreateUserRequested value)? createUser,
    TResult? Function(_DeleteUserRequested value)? deleteUser,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_UserEventLoading value)? loading,
    TResult Function(_GetUserByIdRequested value)? getUserById,
    TResult Function(_GetUsersRequested value)? getUsers,
    TResult Function(_CreateUserRequested value)? createUser,
    TResult Function(_DeleteUserRequested value)? deleteUser,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserEventCopyWith<$Res> {
  factory $UserEventCopyWith(UserEvent value, $Res Function(UserEvent) then) =
      _$UserEventCopyWithImpl<$Res, UserEvent>;
}

/// @nodoc
class _$UserEventCopyWithImpl<$Res, $Val extends UserEvent>
    implements $UserEventCopyWith<$Res> {
  _$UserEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$UserEventLoadingImplCopyWith<$Res> {
  factory _$$UserEventLoadingImplCopyWith(
    _$UserEventLoadingImpl value,
    $Res Function(_$UserEventLoadingImpl) then,
  ) = __$$UserEventLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UserEventLoadingImplCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$UserEventLoadingImpl>
    implements _$$UserEventLoadingImplCopyWith<$Res> {
  __$$UserEventLoadingImplCopyWithImpl(
    _$UserEventLoadingImpl _value,
    $Res Function(_$UserEventLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UserEventLoadingImpl implements _UserEventLoading {
  const _$UserEventLoadingImpl();

  @override
  String toString() {
    return 'UserEvent.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UserEventLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(int id) getUserById,
    required TResult Function() getUsers,
    required TResult Function(User user) createUser,
    required TResult Function(int id) deleteUser,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(int id)? getUserById,
    TResult? Function()? getUsers,
    TResult? Function(User user)? createUser,
    TResult? Function(int id)? deleteUser,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(int id)? getUserById,
    TResult Function()? getUsers,
    TResult Function(User user)? createUser,
    TResult Function(int id)? deleteUser,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_UserEventLoading value) loading,
    required TResult Function(_GetUserByIdRequested value) getUserById,
    required TResult Function(_GetUsersRequested value) getUsers,
    required TResult Function(_CreateUserRequested value) createUser,
    required TResult Function(_DeleteUserRequested value) deleteUser,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_UserEventLoading value)? loading,
    TResult? Function(_GetUserByIdRequested value)? getUserById,
    TResult? Function(_GetUsersRequested value)? getUsers,
    TResult? Function(_CreateUserRequested value)? createUser,
    TResult? Function(_DeleteUserRequested value)? deleteUser,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_UserEventLoading value)? loading,
    TResult Function(_GetUserByIdRequested value)? getUserById,
    TResult Function(_GetUsersRequested value)? getUsers,
    TResult Function(_CreateUserRequested value)? createUser,
    TResult Function(_DeleteUserRequested value)? deleteUser,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _UserEventLoading implements UserEvent {
  const factory _UserEventLoading() = _$UserEventLoadingImpl;
}

/// @nodoc
abstract class _$$GetUserByIdRequestedImplCopyWith<$Res> {
  factory _$$GetUserByIdRequestedImplCopyWith(
    _$GetUserByIdRequestedImpl value,
    $Res Function(_$GetUserByIdRequestedImpl) then,
  ) = __$$GetUserByIdRequestedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int id});
}

/// @nodoc
class __$$GetUserByIdRequestedImplCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$GetUserByIdRequestedImpl>
    implements _$$GetUserByIdRequestedImplCopyWith<$Res> {
  __$$GetUserByIdRequestedImplCopyWithImpl(
    _$GetUserByIdRequestedImpl _value,
    $Res Function(_$GetUserByIdRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null}) {
    return _then(
      _$GetUserByIdRequestedImpl(
        null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$GetUserByIdRequestedImpl implements _GetUserByIdRequested {
  const _$GetUserByIdRequestedImpl(this.id);

  @override
  final int id;

  @override
  String toString() {
    return 'UserEvent.getUserById(id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetUserByIdRequestedImpl &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetUserByIdRequestedImplCopyWith<_$GetUserByIdRequestedImpl>
  get copyWith =>
      __$$GetUserByIdRequestedImplCopyWithImpl<_$GetUserByIdRequestedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(int id) getUserById,
    required TResult Function() getUsers,
    required TResult Function(User user) createUser,
    required TResult Function(int id) deleteUser,
  }) {
    return getUserById(id);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(int id)? getUserById,
    TResult? Function()? getUsers,
    TResult? Function(User user)? createUser,
    TResult? Function(int id)? deleteUser,
  }) {
    return getUserById?.call(id);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(int id)? getUserById,
    TResult Function()? getUsers,
    TResult Function(User user)? createUser,
    TResult Function(int id)? deleteUser,
    required TResult orElse(),
  }) {
    if (getUserById != null) {
      return getUserById(id);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_UserEventLoading value) loading,
    required TResult Function(_GetUserByIdRequested value) getUserById,
    required TResult Function(_GetUsersRequested value) getUsers,
    required TResult Function(_CreateUserRequested value) createUser,
    required TResult Function(_DeleteUserRequested value) deleteUser,
  }) {
    return getUserById(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_UserEventLoading value)? loading,
    TResult? Function(_GetUserByIdRequested value)? getUserById,
    TResult? Function(_GetUsersRequested value)? getUsers,
    TResult? Function(_CreateUserRequested value)? createUser,
    TResult? Function(_DeleteUserRequested value)? deleteUser,
  }) {
    return getUserById?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_UserEventLoading value)? loading,
    TResult Function(_GetUserByIdRequested value)? getUserById,
    TResult Function(_GetUsersRequested value)? getUsers,
    TResult Function(_CreateUserRequested value)? createUser,
    TResult Function(_DeleteUserRequested value)? deleteUser,
    required TResult orElse(),
  }) {
    if (getUserById != null) {
      return getUserById(this);
    }
    return orElse();
  }
}

abstract class _GetUserByIdRequested implements UserEvent {
  const factory _GetUserByIdRequested(final int id) =
      _$GetUserByIdRequestedImpl;

  int get id;

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetUserByIdRequestedImplCopyWith<_$GetUserByIdRequestedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GetUsersRequestedImplCopyWith<$Res> {
  factory _$$GetUsersRequestedImplCopyWith(
    _$GetUsersRequestedImpl value,
    $Res Function(_$GetUsersRequestedImpl) then,
  ) = __$$GetUsersRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GetUsersRequestedImplCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$GetUsersRequestedImpl>
    implements _$$GetUsersRequestedImplCopyWith<$Res> {
  __$$GetUsersRequestedImplCopyWithImpl(
    _$GetUsersRequestedImpl _value,
    $Res Function(_$GetUsersRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GetUsersRequestedImpl implements _GetUsersRequested {
  const _$GetUsersRequestedImpl();

  @override
  String toString() {
    return 'UserEvent.getUsers()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$GetUsersRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(int id) getUserById,
    required TResult Function() getUsers,
    required TResult Function(User user) createUser,
    required TResult Function(int id) deleteUser,
  }) {
    return getUsers();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(int id)? getUserById,
    TResult? Function()? getUsers,
    TResult? Function(User user)? createUser,
    TResult? Function(int id)? deleteUser,
  }) {
    return getUsers?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(int id)? getUserById,
    TResult Function()? getUsers,
    TResult Function(User user)? createUser,
    TResult Function(int id)? deleteUser,
    required TResult orElse(),
  }) {
    if (getUsers != null) {
      return getUsers();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_UserEventLoading value) loading,
    required TResult Function(_GetUserByIdRequested value) getUserById,
    required TResult Function(_GetUsersRequested value) getUsers,
    required TResult Function(_CreateUserRequested value) createUser,
    required TResult Function(_DeleteUserRequested value) deleteUser,
  }) {
    return getUsers(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_UserEventLoading value)? loading,
    TResult? Function(_GetUserByIdRequested value)? getUserById,
    TResult? Function(_GetUsersRequested value)? getUsers,
    TResult? Function(_CreateUserRequested value)? createUser,
    TResult? Function(_DeleteUserRequested value)? deleteUser,
  }) {
    return getUsers?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_UserEventLoading value)? loading,
    TResult Function(_GetUserByIdRequested value)? getUserById,
    TResult Function(_GetUsersRequested value)? getUsers,
    TResult Function(_CreateUserRequested value)? createUser,
    TResult Function(_DeleteUserRequested value)? deleteUser,
    required TResult orElse(),
  }) {
    if (getUsers != null) {
      return getUsers(this);
    }
    return orElse();
  }
}

abstract class _GetUsersRequested implements UserEvent {
  const factory _GetUsersRequested() = _$GetUsersRequestedImpl;
}

/// @nodoc
abstract class _$$CreateUserRequestedImplCopyWith<$Res> {
  factory _$$CreateUserRequestedImplCopyWith(
    _$CreateUserRequestedImpl value,
    $Res Function(_$CreateUserRequestedImpl) then,
  ) = __$$CreateUserRequestedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({User user});
}

/// @nodoc
class __$$CreateUserRequestedImplCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$CreateUserRequestedImpl>
    implements _$$CreateUserRequestedImplCopyWith<$Res> {
  __$$CreateUserRequestedImplCopyWithImpl(
    _$CreateUserRequestedImpl _value,
    $Res Function(_$CreateUserRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null}) {
    return _then(
      _$CreateUserRequestedImpl(
        null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User,
      ),
    );
  }
}

/// @nodoc

class _$CreateUserRequestedImpl implements _CreateUserRequested {
  const _$CreateUserRequestedImpl(this.user);

  @override
  final User user;

  @override
  String toString() {
    return 'UserEvent.createUser(user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateUserRequestedImpl &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateUserRequestedImplCopyWith<_$CreateUserRequestedImpl> get copyWith =>
      __$$CreateUserRequestedImplCopyWithImpl<_$CreateUserRequestedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(int id) getUserById,
    required TResult Function() getUsers,
    required TResult Function(User user) createUser,
    required TResult Function(int id) deleteUser,
  }) {
    return createUser(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(int id)? getUserById,
    TResult? Function()? getUsers,
    TResult? Function(User user)? createUser,
    TResult? Function(int id)? deleteUser,
  }) {
    return createUser?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(int id)? getUserById,
    TResult Function()? getUsers,
    TResult Function(User user)? createUser,
    TResult Function(int id)? deleteUser,
    required TResult orElse(),
  }) {
    if (createUser != null) {
      return createUser(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_UserEventLoading value) loading,
    required TResult Function(_GetUserByIdRequested value) getUserById,
    required TResult Function(_GetUsersRequested value) getUsers,
    required TResult Function(_CreateUserRequested value) createUser,
    required TResult Function(_DeleteUserRequested value) deleteUser,
  }) {
    return createUser(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_UserEventLoading value)? loading,
    TResult? Function(_GetUserByIdRequested value)? getUserById,
    TResult? Function(_GetUsersRequested value)? getUsers,
    TResult? Function(_CreateUserRequested value)? createUser,
    TResult? Function(_DeleteUserRequested value)? deleteUser,
  }) {
    return createUser?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_UserEventLoading value)? loading,
    TResult Function(_GetUserByIdRequested value)? getUserById,
    TResult Function(_GetUsersRequested value)? getUsers,
    TResult Function(_CreateUserRequested value)? createUser,
    TResult Function(_DeleteUserRequested value)? deleteUser,
    required TResult orElse(),
  }) {
    if (createUser != null) {
      return createUser(this);
    }
    return orElse();
  }
}

abstract class _CreateUserRequested implements UserEvent {
  const factory _CreateUserRequested(final User user) =
      _$CreateUserRequestedImpl;

  User get user;

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateUserRequestedImplCopyWith<_$CreateUserRequestedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeleteUserRequestedImplCopyWith<$Res> {
  factory _$$DeleteUserRequestedImplCopyWith(
    _$DeleteUserRequestedImpl value,
    $Res Function(_$DeleteUserRequestedImpl) then,
  ) = __$$DeleteUserRequestedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int id});
}

/// @nodoc
class __$$DeleteUserRequestedImplCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$DeleteUserRequestedImpl>
    implements _$$DeleteUserRequestedImplCopyWith<$Res> {
  __$$DeleteUserRequestedImplCopyWithImpl(
    _$DeleteUserRequestedImpl _value,
    $Res Function(_$DeleteUserRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null}) {
    return _then(
      _$DeleteUserRequestedImpl(
        null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$DeleteUserRequestedImpl implements _DeleteUserRequested {
  const _$DeleteUserRequestedImpl(this.id);

  @override
  final int id;

  @override
  String toString() {
    return 'UserEvent.deleteUser(id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteUserRequestedImpl &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteUserRequestedImplCopyWith<_$DeleteUserRequestedImpl> get copyWith =>
      __$$DeleteUserRequestedImplCopyWithImpl<_$DeleteUserRequestedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(int id) getUserById,
    required TResult Function() getUsers,
    required TResult Function(User user) createUser,
    required TResult Function(int id) deleteUser,
  }) {
    return deleteUser(id);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(int id)? getUserById,
    TResult? Function()? getUsers,
    TResult? Function(User user)? createUser,
    TResult? Function(int id)? deleteUser,
  }) {
    return deleteUser?.call(id);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(int id)? getUserById,
    TResult Function()? getUsers,
    TResult Function(User user)? createUser,
    TResult Function(int id)? deleteUser,
    required TResult orElse(),
  }) {
    if (deleteUser != null) {
      return deleteUser(id);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_UserEventLoading value) loading,
    required TResult Function(_GetUserByIdRequested value) getUserById,
    required TResult Function(_GetUsersRequested value) getUsers,
    required TResult Function(_CreateUserRequested value) createUser,
    required TResult Function(_DeleteUserRequested value) deleteUser,
  }) {
    return deleteUser(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_UserEventLoading value)? loading,
    TResult? Function(_GetUserByIdRequested value)? getUserById,
    TResult? Function(_GetUsersRequested value)? getUsers,
    TResult? Function(_CreateUserRequested value)? createUser,
    TResult? Function(_DeleteUserRequested value)? deleteUser,
  }) {
    return deleteUser?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_UserEventLoading value)? loading,
    TResult Function(_GetUserByIdRequested value)? getUserById,
    TResult Function(_GetUsersRequested value)? getUsers,
    TResult Function(_CreateUserRequested value)? createUser,
    TResult Function(_DeleteUserRequested value)? deleteUser,
    required TResult orElse(),
  }) {
    if (deleteUser != null) {
      return deleteUser(this);
    }
    return orElse();
  }
}

abstract class _DeleteUserRequested implements UserEvent {
  const factory _DeleteUserRequested(final int id) = _$DeleteUserRequestedImpl;

  int get id;

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteUserRequestedImplCopyWith<_$DeleteUserRequestedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UserState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) failure,
    required TResult Function(User data) getUserByIdResult,
    required TResult Function(List<User> data) getUsersResult,
    required TResult Function() createUserResult,
    required TResult Function() deleteUserResult,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? failure,
    TResult? Function(User data)? getUserByIdResult,
    TResult? Function(List<User> data)? getUsersResult,
    TResult? Function()? createUserResult,
    TResult? Function()? deleteUserResult,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? failure,
    TResult Function(User data)? getUserByIdResult,
    TResult Function(List<User> data)? getUsersResult,
    TResult Function()? createUserResult,
    TResult Function()? deleteUserResult,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialDone value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Failure value) failure,
    required TResult Function(_GetUserByIdResult value) getUserByIdResult,
    required TResult Function(_GetUsersResult value) getUsersResult,
    required TResult Function(_CreateUserResult value) createUserResult,
    required TResult Function(_DeleteUserResult value) deleteUserResult,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialDone value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Failure value)? failure,
    TResult? Function(_GetUserByIdResult value)? getUserByIdResult,
    TResult? Function(_GetUsersResult value)? getUsersResult,
    TResult? Function(_CreateUserResult value)? createUserResult,
    TResult? Function(_DeleteUserResult value)? deleteUserResult,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialDone value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Failure value)? failure,
    TResult Function(_GetUserByIdResult value)? getUserByIdResult,
    TResult Function(_GetUsersResult value)? getUsersResult,
    TResult Function(_CreateUserResult value)? createUserResult,
    TResult Function(_DeleteUserResult value)? deleteUserResult,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStateCopyWith<$Res> {
  factory $UserStateCopyWith(UserState value, $Res Function(UserState) then) =
      _$UserStateCopyWithImpl<$Res, UserState>;
}

/// @nodoc
class _$UserStateCopyWithImpl<$Res, $Val extends UserState>
    implements $UserStateCopyWith<$Res> {
  _$UserStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialDoneImplCopyWith<$Res> {
  factory _$$InitialDoneImplCopyWith(
    _$InitialDoneImpl value,
    $Res Function(_$InitialDoneImpl) then,
  ) = __$$InitialDoneImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialDoneImplCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$InitialDoneImpl>
    implements _$$InitialDoneImplCopyWith<$Res> {
  __$$InitialDoneImplCopyWithImpl(
    _$InitialDoneImpl _value,
    $Res Function(_$InitialDoneImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialDoneImpl implements _InitialDone {
  const _$InitialDoneImpl();

  @override
  String toString() {
    return 'UserState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialDoneImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) failure,
    required TResult Function(User data) getUserByIdResult,
    required TResult Function(List<User> data) getUsersResult,
    required TResult Function() createUserResult,
    required TResult Function() deleteUserResult,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? failure,
    TResult? Function(User data)? getUserByIdResult,
    TResult? Function(List<User> data)? getUsersResult,
    TResult? Function()? createUserResult,
    TResult? Function()? deleteUserResult,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? failure,
    TResult Function(User data)? getUserByIdResult,
    TResult Function(List<User> data)? getUsersResult,
    TResult Function()? createUserResult,
    TResult Function()? deleteUserResult,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialDone value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Failure value) failure,
    required TResult Function(_GetUserByIdResult value) getUserByIdResult,
    required TResult Function(_GetUsersResult value) getUsersResult,
    required TResult Function(_CreateUserResult value) createUserResult,
    required TResult Function(_DeleteUserResult value) deleteUserResult,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialDone value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Failure value)? failure,
    TResult? Function(_GetUserByIdResult value)? getUserByIdResult,
    TResult? Function(_GetUsersResult value)? getUsersResult,
    TResult? Function(_CreateUserResult value)? createUserResult,
    TResult? Function(_DeleteUserResult value)? deleteUserResult,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialDone value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Failure value)? failure,
    TResult Function(_GetUserByIdResult value)? getUserByIdResult,
    TResult Function(_GetUsersResult value)? getUsersResult,
    TResult Function(_CreateUserResult value)? createUserResult,
    TResult Function(_DeleteUserResult value)? deleteUserResult,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _InitialDone implements UserState {
  const factory _InitialDone() = _$InitialDoneImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
    _$LoadingImpl value,
    $Res Function(_$LoadingImpl) then,
  ) = __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
    _$LoadingImpl _value,
    $Res Function(_$LoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'UserState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) failure,
    required TResult Function(User data) getUserByIdResult,
    required TResult Function(List<User> data) getUsersResult,
    required TResult Function() createUserResult,
    required TResult Function() deleteUserResult,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? failure,
    TResult? Function(User data)? getUserByIdResult,
    TResult? Function(List<User> data)? getUsersResult,
    TResult? Function()? createUserResult,
    TResult? Function()? deleteUserResult,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? failure,
    TResult Function(User data)? getUserByIdResult,
    TResult Function(List<User> data)? getUsersResult,
    TResult Function()? createUserResult,
    TResult Function()? deleteUserResult,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialDone value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Failure value) failure,
    required TResult Function(_GetUserByIdResult value) getUserByIdResult,
    required TResult Function(_GetUsersResult value) getUsersResult,
    required TResult Function(_CreateUserResult value) createUserResult,
    required TResult Function(_DeleteUserResult value) deleteUserResult,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialDone value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Failure value)? failure,
    TResult? Function(_GetUserByIdResult value)? getUserByIdResult,
    TResult? Function(_GetUsersResult value)? getUsersResult,
    TResult? Function(_CreateUserResult value)? createUserResult,
    TResult? Function(_DeleteUserResult value)? deleteUserResult,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialDone value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Failure value)? failure,
    TResult Function(_GetUserByIdResult value)? getUserByIdResult,
    TResult Function(_GetUsersResult value)? getUsersResult,
    TResult Function(_CreateUserResult value)? createUserResult,
    TResult Function(_DeleteUserResult value)? deleteUserResult,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements UserState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$FailureImplCopyWith<$Res> {
  factory _$$FailureImplCopyWith(
    _$FailureImpl value,
    $Res Function(_$FailureImpl) then,
  ) = __$$FailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$FailureImplCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$FailureImpl>
    implements _$$FailureImplCopyWith<$Res> {
  __$$FailureImplCopyWithImpl(
    _$FailureImpl _value,
    $Res Function(_$FailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$FailureImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$FailureImpl implements _Failure {
  const _$FailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'UserState.failure(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FailureImplCopyWith<_$FailureImpl> get copyWith =>
      __$$FailureImplCopyWithImpl<_$FailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) failure,
    required TResult Function(User data) getUserByIdResult,
    required TResult Function(List<User> data) getUsersResult,
    required TResult Function() createUserResult,
    required TResult Function() deleteUserResult,
  }) {
    return failure(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? failure,
    TResult? Function(User data)? getUserByIdResult,
    TResult? Function(List<User> data)? getUsersResult,
    TResult? Function()? createUserResult,
    TResult? Function()? deleteUserResult,
  }) {
    return failure?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? failure,
    TResult Function(User data)? getUserByIdResult,
    TResult Function(List<User> data)? getUsersResult,
    TResult Function()? createUserResult,
    TResult Function()? deleteUserResult,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialDone value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Failure value) failure,
    required TResult Function(_GetUserByIdResult value) getUserByIdResult,
    required TResult Function(_GetUsersResult value) getUsersResult,
    required TResult Function(_CreateUserResult value) createUserResult,
    required TResult Function(_DeleteUserResult value) deleteUserResult,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialDone value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Failure value)? failure,
    TResult? Function(_GetUserByIdResult value)? getUserByIdResult,
    TResult? Function(_GetUsersResult value)? getUsersResult,
    TResult? Function(_CreateUserResult value)? createUserResult,
    TResult? Function(_DeleteUserResult value)? deleteUserResult,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialDone value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Failure value)? failure,
    TResult Function(_GetUserByIdResult value)? getUserByIdResult,
    TResult Function(_GetUsersResult value)? getUsersResult,
    TResult Function(_CreateUserResult value)? createUserResult,
    TResult Function(_DeleteUserResult value)? deleteUserResult,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class _Failure implements UserState {
  const factory _Failure(final String message) = _$FailureImpl;

  String get message;

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FailureImplCopyWith<_$FailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GetUserByIdResultImplCopyWith<$Res> {
  factory _$$GetUserByIdResultImplCopyWith(
    _$GetUserByIdResultImpl value,
    $Res Function(_$GetUserByIdResultImpl) then,
  ) = __$$GetUserByIdResultImplCopyWithImpl<$Res>;
  @useResult
  $Res call({User data});
}

/// @nodoc
class __$$GetUserByIdResultImplCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$GetUserByIdResultImpl>
    implements _$$GetUserByIdResultImplCopyWith<$Res> {
  __$$GetUserByIdResultImplCopyWithImpl(
    _$GetUserByIdResultImpl _value,
    $Res Function(_$GetUserByIdResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null}) {
    return _then(
      _$GetUserByIdResultImpl(
        null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as User,
      ),
    );
  }
}

/// @nodoc

class _$GetUserByIdResultImpl implements _GetUserByIdResult {
  const _$GetUserByIdResultImpl(this.data);

  @override
  final User data;

  @override
  String toString() {
    return 'UserState.getUserByIdResult(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetUserByIdResultImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetUserByIdResultImplCopyWith<_$GetUserByIdResultImpl> get copyWith =>
      __$$GetUserByIdResultImplCopyWithImpl<_$GetUserByIdResultImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) failure,
    required TResult Function(User data) getUserByIdResult,
    required TResult Function(List<User> data) getUsersResult,
    required TResult Function() createUserResult,
    required TResult Function() deleteUserResult,
  }) {
    return getUserByIdResult(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? failure,
    TResult? Function(User data)? getUserByIdResult,
    TResult? Function(List<User> data)? getUsersResult,
    TResult? Function()? createUserResult,
    TResult? Function()? deleteUserResult,
  }) {
    return getUserByIdResult?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? failure,
    TResult Function(User data)? getUserByIdResult,
    TResult Function(List<User> data)? getUsersResult,
    TResult Function()? createUserResult,
    TResult Function()? deleteUserResult,
    required TResult orElse(),
  }) {
    if (getUserByIdResult != null) {
      return getUserByIdResult(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialDone value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Failure value) failure,
    required TResult Function(_GetUserByIdResult value) getUserByIdResult,
    required TResult Function(_GetUsersResult value) getUsersResult,
    required TResult Function(_CreateUserResult value) createUserResult,
    required TResult Function(_DeleteUserResult value) deleteUserResult,
  }) {
    return getUserByIdResult(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialDone value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Failure value)? failure,
    TResult? Function(_GetUserByIdResult value)? getUserByIdResult,
    TResult? Function(_GetUsersResult value)? getUsersResult,
    TResult? Function(_CreateUserResult value)? createUserResult,
    TResult? Function(_DeleteUserResult value)? deleteUserResult,
  }) {
    return getUserByIdResult?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialDone value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Failure value)? failure,
    TResult Function(_GetUserByIdResult value)? getUserByIdResult,
    TResult Function(_GetUsersResult value)? getUsersResult,
    TResult Function(_CreateUserResult value)? createUserResult,
    TResult Function(_DeleteUserResult value)? deleteUserResult,
    required TResult orElse(),
  }) {
    if (getUserByIdResult != null) {
      return getUserByIdResult(this);
    }
    return orElse();
  }
}

abstract class _GetUserByIdResult implements UserState {
  const factory _GetUserByIdResult(final User data) = _$GetUserByIdResultImpl;

  User get data;

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetUserByIdResultImplCopyWith<_$GetUserByIdResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GetUsersResultImplCopyWith<$Res> {
  factory _$$GetUsersResultImplCopyWith(
    _$GetUsersResultImpl value,
    $Res Function(_$GetUsersResultImpl) then,
  ) = __$$GetUsersResultImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<User> data});
}

/// @nodoc
class __$$GetUsersResultImplCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$GetUsersResultImpl>
    implements _$$GetUsersResultImplCopyWith<$Res> {
  __$$GetUsersResultImplCopyWithImpl(
    _$GetUsersResultImpl _value,
    $Res Function(_$GetUsersResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null}) {
    return _then(
      _$GetUsersResultImpl(
        null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<User>,
      ),
    );
  }
}

/// @nodoc

class _$GetUsersResultImpl implements _GetUsersResult {
  const _$GetUsersResultImpl(final List<User> data) : _data = data;

  final List<User> _data;
  @override
  List<User> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'UserState.getUsersResult(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetUsersResultImpl &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetUsersResultImplCopyWith<_$GetUsersResultImpl> get copyWith =>
      __$$GetUsersResultImplCopyWithImpl<_$GetUsersResultImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) failure,
    required TResult Function(User data) getUserByIdResult,
    required TResult Function(List<User> data) getUsersResult,
    required TResult Function() createUserResult,
    required TResult Function() deleteUserResult,
  }) {
    return getUsersResult(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? failure,
    TResult? Function(User data)? getUserByIdResult,
    TResult? Function(List<User> data)? getUsersResult,
    TResult? Function()? createUserResult,
    TResult? Function()? deleteUserResult,
  }) {
    return getUsersResult?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? failure,
    TResult Function(User data)? getUserByIdResult,
    TResult Function(List<User> data)? getUsersResult,
    TResult Function()? createUserResult,
    TResult Function()? deleteUserResult,
    required TResult orElse(),
  }) {
    if (getUsersResult != null) {
      return getUsersResult(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialDone value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Failure value) failure,
    required TResult Function(_GetUserByIdResult value) getUserByIdResult,
    required TResult Function(_GetUsersResult value) getUsersResult,
    required TResult Function(_CreateUserResult value) createUserResult,
    required TResult Function(_DeleteUserResult value) deleteUserResult,
  }) {
    return getUsersResult(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialDone value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Failure value)? failure,
    TResult? Function(_GetUserByIdResult value)? getUserByIdResult,
    TResult? Function(_GetUsersResult value)? getUsersResult,
    TResult? Function(_CreateUserResult value)? createUserResult,
    TResult? Function(_DeleteUserResult value)? deleteUserResult,
  }) {
    return getUsersResult?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialDone value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Failure value)? failure,
    TResult Function(_GetUserByIdResult value)? getUserByIdResult,
    TResult Function(_GetUsersResult value)? getUsersResult,
    TResult Function(_CreateUserResult value)? createUserResult,
    TResult Function(_DeleteUserResult value)? deleteUserResult,
    required TResult orElse(),
  }) {
    if (getUsersResult != null) {
      return getUsersResult(this);
    }
    return orElse();
  }
}

abstract class _GetUsersResult implements UserState {
  const factory _GetUsersResult(final List<User> data) = _$GetUsersResultImpl;

  List<User> get data;

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetUsersResultImplCopyWith<_$GetUsersResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CreateUserResultImplCopyWith<$Res> {
  factory _$$CreateUserResultImplCopyWith(
    _$CreateUserResultImpl value,
    $Res Function(_$CreateUserResultImpl) then,
  ) = __$$CreateUserResultImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CreateUserResultImplCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$CreateUserResultImpl>
    implements _$$CreateUserResultImplCopyWith<$Res> {
  __$$CreateUserResultImplCopyWithImpl(
    _$CreateUserResultImpl _value,
    $Res Function(_$CreateUserResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CreateUserResultImpl implements _CreateUserResult {
  const _$CreateUserResultImpl();

  @override
  String toString() {
    return 'UserState.createUserResult()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CreateUserResultImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) failure,
    required TResult Function(User data) getUserByIdResult,
    required TResult Function(List<User> data) getUsersResult,
    required TResult Function() createUserResult,
    required TResult Function() deleteUserResult,
  }) {
    return createUserResult();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? failure,
    TResult? Function(User data)? getUserByIdResult,
    TResult? Function(List<User> data)? getUsersResult,
    TResult? Function()? createUserResult,
    TResult? Function()? deleteUserResult,
  }) {
    return createUserResult?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? failure,
    TResult Function(User data)? getUserByIdResult,
    TResult Function(List<User> data)? getUsersResult,
    TResult Function()? createUserResult,
    TResult Function()? deleteUserResult,
    required TResult orElse(),
  }) {
    if (createUserResult != null) {
      return createUserResult();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialDone value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Failure value) failure,
    required TResult Function(_GetUserByIdResult value) getUserByIdResult,
    required TResult Function(_GetUsersResult value) getUsersResult,
    required TResult Function(_CreateUserResult value) createUserResult,
    required TResult Function(_DeleteUserResult value) deleteUserResult,
  }) {
    return createUserResult(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialDone value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Failure value)? failure,
    TResult? Function(_GetUserByIdResult value)? getUserByIdResult,
    TResult? Function(_GetUsersResult value)? getUsersResult,
    TResult? Function(_CreateUserResult value)? createUserResult,
    TResult? Function(_DeleteUserResult value)? deleteUserResult,
  }) {
    return createUserResult?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialDone value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Failure value)? failure,
    TResult Function(_GetUserByIdResult value)? getUserByIdResult,
    TResult Function(_GetUsersResult value)? getUsersResult,
    TResult Function(_CreateUserResult value)? createUserResult,
    TResult Function(_DeleteUserResult value)? deleteUserResult,
    required TResult orElse(),
  }) {
    if (createUserResult != null) {
      return createUserResult(this);
    }
    return orElse();
  }
}

abstract class _CreateUserResult implements UserState {
  const factory _CreateUserResult() = _$CreateUserResultImpl;
}

/// @nodoc
abstract class _$$DeleteUserResultImplCopyWith<$Res> {
  factory _$$DeleteUserResultImplCopyWith(
    _$DeleteUserResultImpl value,
    $Res Function(_$DeleteUserResultImpl) then,
  ) = __$$DeleteUserResultImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeleteUserResultImplCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$DeleteUserResultImpl>
    implements _$$DeleteUserResultImplCopyWith<$Res> {
  __$$DeleteUserResultImplCopyWithImpl(
    _$DeleteUserResultImpl _value,
    $Res Function(_$DeleteUserResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DeleteUserResultImpl implements _DeleteUserResult {
  const _$DeleteUserResultImpl();

  @override
  String toString() {
    return 'UserState.deleteUserResult()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DeleteUserResultImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) failure,
    required TResult Function(User data) getUserByIdResult,
    required TResult Function(List<User> data) getUsersResult,
    required TResult Function() createUserResult,
    required TResult Function() deleteUserResult,
  }) {
    return deleteUserResult();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? failure,
    TResult? Function(User data)? getUserByIdResult,
    TResult? Function(List<User> data)? getUsersResult,
    TResult? Function()? createUserResult,
    TResult? Function()? deleteUserResult,
  }) {
    return deleteUserResult?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? failure,
    TResult Function(User data)? getUserByIdResult,
    TResult Function(List<User> data)? getUsersResult,
    TResult Function()? createUserResult,
    TResult Function()? deleteUserResult,
    required TResult orElse(),
  }) {
    if (deleteUserResult != null) {
      return deleteUserResult();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialDone value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Failure value) failure,
    required TResult Function(_GetUserByIdResult value) getUserByIdResult,
    required TResult Function(_GetUsersResult value) getUsersResult,
    required TResult Function(_CreateUserResult value) createUserResult,
    required TResult Function(_DeleteUserResult value) deleteUserResult,
  }) {
    return deleteUserResult(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialDone value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Failure value)? failure,
    TResult? Function(_GetUserByIdResult value)? getUserByIdResult,
    TResult? Function(_GetUsersResult value)? getUsersResult,
    TResult? Function(_CreateUserResult value)? createUserResult,
    TResult? Function(_DeleteUserResult value)? deleteUserResult,
  }) {
    return deleteUserResult?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialDone value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Failure value)? failure,
    TResult Function(_GetUserByIdResult value)? getUserByIdResult,
    TResult Function(_GetUsersResult value)? getUsersResult,
    TResult Function(_CreateUserResult value)? createUserResult,
    TResult Function(_DeleteUserResult value)? deleteUserResult,
    required TResult orElse(),
  }) {
    if (deleteUserResult != null) {
      return deleteUserResult(this);
    }
    return orElse();
  }
}

abstract class _DeleteUserResult implements UserState {
  const factory _DeleteUserResult() = _$DeleteUserResultImpl;
}
