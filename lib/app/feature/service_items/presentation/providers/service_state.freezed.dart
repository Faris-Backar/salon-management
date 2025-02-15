// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ServiceItemState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ServiceItemEntity> serviceItems)
        serviceItemsFetched,
    required TResult Function(bool isSuccess) createServiceItemsuccess,
    required TResult Function(bool isSuccess) updateServiceItemsuccess,
    required TResult Function(bool isSuccess) deleteServiceItemsuccess,
    required TResult Function(String error) failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ServiceItemEntity> serviceItems)?
        serviceItemsFetched,
    TResult? Function(bool isSuccess)? createServiceItemsuccess,
    TResult? Function(bool isSuccess)? updateServiceItemsuccess,
    TResult? Function(bool isSuccess)? deleteServiceItemsuccess,
    TResult? Function(String error)? failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ServiceItemEntity> serviceItems)? serviceItemsFetched,
    TResult Function(bool isSuccess)? createServiceItemsuccess,
    TResult Function(bool isSuccess)? updateServiceItemsuccess,
    TResult Function(bool isSuccess)? deleteServiceItemsuccess,
    TResult Function(String error)? failed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_CustomerFetched value) serviceItemsFetched,
    required TResult Function(_CreateServiceItemsuccess value)
        createServiceItemsuccess,
    required TResult Function(_UpdateServiceItemsuccess value)
        updateServiceItemsuccess,
    required TResult Function(_DeleteServiceItemsuccess value)
        deleteServiceItemsuccess,
    required TResult Function(_Failed value) failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_CustomerFetched value)? serviceItemsFetched,
    TResult? Function(_CreateServiceItemsuccess value)?
        createServiceItemsuccess,
    TResult? Function(_UpdateServiceItemsuccess value)?
        updateServiceItemsuccess,
    TResult? Function(_DeleteServiceItemsuccess value)?
        deleteServiceItemsuccess,
    TResult? Function(_Failed value)? failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_CustomerFetched value)? serviceItemsFetched,
    TResult Function(_CreateServiceItemsuccess value)? createServiceItemsuccess,
    TResult Function(_UpdateServiceItemsuccess value)? updateServiceItemsuccess,
    TResult Function(_DeleteServiceItemsuccess value)? deleteServiceItemsuccess,
    TResult Function(_Failed value)? failed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceItemStateCopyWith<$Res> {
  factory $ServiceItemStateCopyWith(
          ServiceItemState value, $Res Function(ServiceItemState) then) =
      _$ServiceItemStateCopyWithImpl<$Res, ServiceItemState>;
}

/// @nodoc
class _$ServiceItemStateCopyWithImpl<$Res, $Val extends ServiceItemState>
    implements $ServiceItemStateCopyWith<$Res> {
  _$ServiceItemStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceItemState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$ServiceItemStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServiceItemState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'ServiceItemState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ServiceItemEntity> serviceItems)
        serviceItemsFetched,
    required TResult Function(bool isSuccess) createServiceItemsuccess,
    required TResult Function(bool isSuccess) updateServiceItemsuccess,
    required TResult Function(bool isSuccess) deleteServiceItemsuccess,
    required TResult Function(String error) failed,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ServiceItemEntity> serviceItems)?
        serviceItemsFetched,
    TResult? Function(bool isSuccess)? createServiceItemsuccess,
    TResult? Function(bool isSuccess)? updateServiceItemsuccess,
    TResult? Function(bool isSuccess)? deleteServiceItemsuccess,
    TResult? Function(String error)? failed,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ServiceItemEntity> serviceItems)? serviceItemsFetched,
    TResult Function(bool isSuccess)? createServiceItemsuccess,
    TResult Function(bool isSuccess)? updateServiceItemsuccess,
    TResult Function(bool isSuccess)? deleteServiceItemsuccess,
    TResult Function(String error)? failed,
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
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_CustomerFetched value) serviceItemsFetched,
    required TResult Function(_CreateServiceItemsuccess value)
        createServiceItemsuccess,
    required TResult Function(_UpdateServiceItemsuccess value)
        updateServiceItemsuccess,
    required TResult Function(_DeleteServiceItemsuccess value)
        deleteServiceItemsuccess,
    required TResult Function(_Failed value) failed,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_CustomerFetched value)? serviceItemsFetched,
    TResult? Function(_CreateServiceItemsuccess value)?
        createServiceItemsuccess,
    TResult? Function(_UpdateServiceItemsuccess value)?
        updateServiceItemsuccess,
    TResult? Function(_DeleteServiceItemsuccess value)?
        deleteServiceItemsuccess,
    TResult? Function(_Failed value)? failed,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_CustomerFetched value)? serviceItemsFetched,
    TResult Function(_CreateServiceItemsuccess value)? createServiceItemsuccess,
    TResult Function(_UpdateServiceItemsuccess value)? updateServiceItemsuccess,
    TResult Function(_DeleteServiceItemsuccess value)? deleteServiceItemsuccess,
    TResult Function(_Failed value)? failed,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements ServiceItemState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$ServiceItemStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServiceItemState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'ServiceItemState.loading()';
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
    required TResult Function(List<ServiceItemEntity> serviceItems)
        serviceItemsFetched,
    required TResult Function(bool isSuccess) createServiceItemsuccess,
    required TResult Function(bool isSuccess) updateServiceItemsuccess,
    required TResult Function(bool isSuccess) deleteServiceItemsuccess,
    required TResult Function(String error) failed,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ServiceItemEntity> serviceItems)?
        serviceItemsFetched,
    TResult? Function(bool isSuccess)? createServiceItemsuccess,
    TResult? Function(bool isSuccess)? updateServiceItemsuccess,
    TResult? Function(bool isSuccess)? deleteServiceItemsuccess,
    TResult? Function(String error)? failed,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ServiceItemEntity> serviceItems)? serviceItemsFetched,
    TResult Function(bool isSuccess)? createServiceItemsuccess,
    TResult Function(bool isSuccess)? updateServiceItemsuccess,
    TResult Function(bool isSuccess)? deleteServiceItemsuccess,
    TResult Function(String error)? failed,
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
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_CustomerFetched value) serviceItemsFetched,
    required TResult Function(_CreateServiceItemsuccess value)
        createServiceItemsuccess,
    required TResult Function(_UpdateServiceItemsuccess value)
        updateServiceItemsuccess,
    required TResult Function(_DeleteServiceItemsuccess value)
        deleteServiceItemsuccess,
    required TResult Function(_Failed value) failed,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_CustomerFetched value)? serviceItemsFetched,
    TResult? Function(_CreateServiceItemsuccess value)?
        createServiceItemsuccess,
    TResult? Function(_UpdateServiceItemsuccess value)?
        updateServiceItemsuccess,
    TResult? Function(_DeleteServiceItemsuccess value)?
        deleteServiceItemsuccess,
    TResult? Function(_Failed value)? failed,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_CustomerFetched value)? serviceItemsFetched,
    TResult Function(_CreateServiceItemsuccess value)? createServiceItemsuccess,
    TResult Function(_UpdateServiceItemsuccess value)? updateServiceItemsuccess,
    TResult Function(_DeleteServiceItemsuccess value)? deleteServiceItemsuccess,
    TResult Function(_Failed value)? failed,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements ServiceItemState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$CustomerFetchedImplCopyWith<$Res> {
  factory _$$CustomerFetchedImplCopyWith(_$CustomerFetchedImpl value,
          $Res Function(_$CustomerFetchedImpl) then) =
      __$$CustomerFetchedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<ServiceItemEntity> serviceItems});
}

/// @nodoc
class __$$CustomerFetchedImplCopyWithImpl<$Res>
    extends _$ServiceItemStateCopyWithImpl<$Res, _$CustomerFetchedImpl>
    implements _$$CustomerFetchedImplCopyWith<$Res> {
  __$$CustomerFetchedImplCopyWithImpl(
      _$CustomerFetchedImpl _value, $Res Function(_$CustomerFetchedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServiceItemState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceItems = null,
  }) {
    return _then(_$CustomerFetchedImpl(
      serviceItems: null == serviceItems
          ? _value._serviceItems
          : serviceItems // ignore: cast_nullable_to_non_nullable
              as List<ServiceItemEntity>,
    ));
  }
}

/// @nodoc

class _$CustomerFetchedImpl implements _CustomerFetched {
  const _$CustomerFetchedImpl(
      {required final List<ServiceItemEntity> serviceItems})
      : _serviceItems = serviceItems;

  final List<ServiceItemEntity> _serviceItems;
  @override
  List<ServiceItemEntity> get serviceItems {
    if (_serviceItems is EqualUnmodifiableListView) return _serviceItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_serviceItems);
  }

  @override
  String toString() {
    return 'ServiceItemState.serviceItemsFetched(serviceItems: $serviceItems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerFetchedImpl &&
            const DeepCollectionEquality()
                .equals(other._serviceItems, _serviceItems));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_serviceItems));

  /// Create a copy of ServiceItemState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerFetchedImplCopyWith<_$CustomerFetchedImpl> get copyWith =>
      __$$CustomerFetchedImplCopyWithImpl<_$CustomerFetchedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ServiceItemEntity> serviceItems)
        serviceItemsFetched,
    required TResult Function(bool isSuccess) createServiceItemsuccess,
    required TResult Function(bool isSuccess) updateServiceItemsuccess,
    required TResult Function(bool isSuccess) deleteServiceItemsuccess,
    required TResult Function(String error) failed,
  }) {
    return serviceItemsFetched(serviceItems);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ServiceItemEntity> serviceItems)?
        serviceItemsFetched,
    TResult? Function(bool isSuccess)? createServiceItemsuccess,
    TResult? Function(bool isSuccess)? updateServiceItemsuccess,
    TResult? Function(bool isSuccess)? deleteServiceItemsuccess,
    TResult? Function(String error)? failed,
  }) {
    return serviceItemsFetched?.call(serviceItems);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ServiceItemEntity> serviceItems)? serviceItemsFetched,
    TResult Function(bool isSuccess)? createServiceItemsuccess,
    TResult Function(bool isSuccess)? updateServiceItemsuccess,
    TResult Function(bool isSuccess)? deleteServiceItemsuccess,
    TResult Function(String error)? failed,
    required TResult orElse(),
  }) {
    if (serviceItemsFetched != null) {
      return serviceItemsFetched(serviceItems);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_CustomerFetched value) serviceItemsFetched,
    required TResult Function(_CreateServiceItemsuccess value)
        createServiceItemsuccess,
    required TResult Function(_UpdateServiceItemsuccess value)
        updateServiceItemsuccess,
    required TResult Function(_DeleteServiceItemsuccess value)
        deleteServiceItemsuccess,
    required TResult Function(_Failed value) failed,
  }) {
    return serviceItemsFetched(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_CustomerFetched value)? serviceItemsFetched,
    TResult? Function(_CreateServiceItemsuccess value)?
        createServiceItemsuccess,
    TResult? Function(_UpdateServiceItemsuccess value)?
        updateServiceItemsuccess,
    TResult? Function(_DeleteServiceItemsuccess value)?
        deleteServiceItemsuccess,
    TResult? Function(_Failed value)? failed,
  }) {
    return serviceItemsFetched?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_CustomerFetched value)? serviceItemsFetched,
    TResult Function(_CreateServiceItemsuccess value)? createServiceItemsuccess,
    TResult Function(_UpdateServiceItemsuccess value)? updateServiceItemsuccess,
    TResult Function(_DeleteServiceItemsuccess value)? deleteServiceItemsuccess,
    TResult Function(_Failed value)? failed,
    required TResult orElse(),
  }) {
    if (serviceItemsFetched != null) {
      return serviceItemsFetched(this);
    }
    return orElse();
  }
}

abstract class _CustomerFetched implements ServiceItemState {
  const factory _CustomerFetched(
          {required final List<ServiceItemEntity> serviceItems}) =
      _$CustomerFetchedImpl;

  List<ServiceItemEntity> get serviceItems;

  /// Create a copy of ServiceItemState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerFetchedImplCopyWith<_$CustomerFetchedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CreateServiceItemsuccessImplCopyWith<$Res> {
  factory _$$CreateServiceItemsuccessImplCopyWith(
          _$CreateServiceItemsuccessImpl value,
          $Res Function(_$CreateServiceItemsuccessImpl) then) =
      __$$CreateServiceItemsuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool isSuccess});
}

/// @nodoc
class __$$CreateServiceItemsuccessImplCopyWithImpl<$Res>
    extends _$ServiceItemStateCopyWithImpl<$Res, _$CreateServiceItemsuccessImpl>
    implements _$$CreateServiceItemsuccessImplCopyWith<$Res> {
  __$$CreateServiceItemsuccessImplCopyWithImpl(
      _$CreateServiceItemsuccessImpl _value,
      $Res Function(_$CreateServiceItemsuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServiceItemState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSuccess = null,
  }) {
    return _then(_$CreateServiceItemsuccessImpl(
      isSuccess: null == isSuccess
          ? _value.isSuccess
          : isSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$CreateServiceItemsuccessImpl implements _CreateServiceItemsuccess {
  const _$CreateServiceItemsuccessImpl({required this.isSuccess});

  @override
  final bool isSuccess;

  @override
  String toString() {
    return 'ServiceItemState.createServiceItemsuccess(isSuccess: $isSuccess)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateServiceItemsuccessImpl &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isSuccess);

  /// Create a copy of ServiceItemState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateServiceItemsuccessImplCopyWith<_$CreateServiceItemsuccessImpl>
      get copyWith => __$$CreateServiceItemsuccessImplCopyWithImpl<
          _$CreateServiceItemsuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ServiceItemEntity> serviceItems)
        serviceItemsFetched,
    required TResult Function(bool isSuccess) createServiceItemsuccess,
    required TResult Function(bool isSuccess) updateServiceItemsuccess,
    required TResult Function(bool isSuccess) deleteServiceItemsuccess,
    required TResult Function(String error) failed,
  }) {
    return createServiceItemsuccess(isSuccess);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ServiceItemEntity> serviceItems)?
        serviceItemsFetched,
    TResult? Function(bool isSuccess)? createServiceItemsuccess,
    TResult? Function(bool isSuccess)? updateServiceItemsuccess,
    TResult? Function(bool isSuccess)? deleteServiceItemsuccess,
    TResult? Function(String error)? failed,
  }) {
    return createServiceItemsuccess?.call(isSuccess);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ServiceItemEntity> serviceItems)? serviceItemsFetched,
    TResult Function(bool isSuccess)? createServiceItemsuccess,
    TResult Function(bool isSuccess)? updateServiceItemsuccess,
    TResult Function(bool isSuccess)? deleteServiceItemsuccess,
    TResult Function(String error)? failed,
    required TResult orElse(),
  }) {
    if (createServiceItemsuccess != null) {
      return createServiceItemsuccess(isSuccess);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_CustomerFetched value) serviceItemsFetched,
    required TResult Function(_CreateServiceItemsuccess value)
        createServiceItemsuccess,
    required TResult Function(_UpdateServiceItemsuccess value)
        updateServiceItemsuccess,
    required TResult Function(_DeleteServiceItemsuccess value)
        deleteServiceItemsuccess,
    required TResult Function(_Failed value) failed,
  }) {
    return createServiceItemsuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_CustomerFetched value)? serviceItemsFetched,
    TResult? Function(_CreateServiceItemsuccess value)?
        createServiceItemsuccess,
    TResult? Function(_UpdateServiceItemsuccess value)?
        updateServiceItemsuccess,
    TResult? Function(_DeleteServiceItemsuccess value)?
        deleteServiceItemsuccess,
    TResult? Function(_Failed value)? failed,
  }) {
    return createServiceItemsuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_CustomerFetched value)? serviceItemsFetched,
    TResult Function(_CreateServiceItemsuccess value)? createServiceItemsuccess,
    TResult Function(_UpdateServiceItemsuccess value)? updateServiceItemsuccess,
    TResult Function(_DeleteServiceItemsuccess value)? deleteServiceItemsuccess,
    TResult Function(_Failed value)? failed,
    required TResult orElse(),
  }) {
    if (createServiceItemsuccess != null) {
      return createServiceItemsuccess(this);
    }
    return orElse();
  }
}

abstract class _CreateServiceItemsuccess implements ServiceItemState {
  const factory _CreateServiceItemsuccess({required final bool isSuccess}) =
      _$CreateServiceItemsuccessImpl;

  bool get isSuccess;

  /// Create a copy of ServiceItemState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateServiceItemsuccessImplCopyWith<_$CreateServiceItemsuccessImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateServiceItemsuccessImplCopyWith<$Res> {
  factory _$$UpdateServiceItemsuccessImplCopyWith(
          _$UpdateServiceItemsuccessImpl value,
          $Res Function(_$UpdateServiceItemsuccessImpl) then) =
      __$$UpdateServiceItemsuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool isSuccess});
}

/// @nodoc
class __$$UpdateServiceItemsuccessImplCopyWithImpl<$Res>
    extends _$ServiceItemStateCopyWithImpl<$Res, _$UpdateServiceItemsuccessImpl>
    implements _$$UpdateServiceItemsuccessImplCopyWith<$Res> {
  __$$UpdateServiceItemsuccessImplCopyWithImpl(
      _$UpdateServiceItemsuccessImpl _value,
      $Res Function(_$UpdateServiceItemsuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServiceItemState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSuccess = null,
  }) {
    return _then(_$UpdateServiceItemsuccessImpl(
      isSuccess: null == isSuccess
          ? _value.isSuccess
          : isSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$UpdateServiceItemsuccessImpl implements _UpdateServiceItemsuccess {
  const _$UpdateServiceItemsuccessImpl({required this.isSuccess});

  @override
  final bool isSuccess;

  @override
  String toString() {
    return 'ServiceItemState.updateServiceItemsuccess(isSuccess: $isSuccess)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateServiceItemsuccessImpl &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isSuccess);

  /// Create a copy of ServiceItemState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateServiceItemsuccessImplCopyWith<_$UpdateServiceItemsuccessImpl>
      get copyWith => __$$UpdateServiceItemsuccessImplCopyWithImpl<
          _$UpdateServiceItemsuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ServiceItemEntity> serviceItems)
        serviceItemsFetched,
    required TResult Function(bool isSuccess) createServiceItemsuccess,
    required TResult Function(bool isSuccess) updateServiceItemsuccess,
    required TResult Function(bool isSuccess) deleteServiceItemsuccess,
    required TResult Function(String error) failed,
  }) {
    return updateServiceItemsuccess(isSuccess);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ServiceItemEntity> serviceItems)?
        serviceItemsFetched,
    TResult? Function(bool isSuccess)? createServiceItemsuccess,
    TResult? Function(bool isSuccess)? updateServiceItemsuccess,
    TResult? Function(bool isSuccess)? deleteServiceItemsuccess,
    TResult? Function(String error)? failed,
  }) {
    return updateServiceItemsuccess?.call(isSuccess);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ServiceItemEntity> serviceItems)? serviceItemsFetched,
    TResult Function(bool isSuccess)? createServiceItemsuccess,
    TResult Function(bool isSuccess)? updateServiceItemsuccess,
    TResult Function(bool isSuccess)? deleteServiceItemsuccess,
    TResult Function(String error)? failed,
    required TResult orElse(),
  }) {
    if (updateServiceItemsuccess != null) {
      return updateServiceItemsuccess(isSuccess);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_CustomerFetched value) serviceItemsFetched,
    required TResult Function(_CreateServiceItemsuccess value)
        createServiceItemsuccess,
    required TResult Function(_UpdateServiceItemsuccess value)
        updateServiceItemsuccess,
    required TResult Function(_DeleteServiceItemsuccess value)
        deleteServiceItemsuccess,
    required TResult Function(_Failed value) failed,
  }) {
    return updateServiceItemsuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_CustomerFetched value)? serviceItemsFetched,
    TResult? Function(_CreateServiceItemsuccess value)?
        createServiceItemsuccess,
    TResult? Function(_UpdateServiceItemsuccess value)?
        updateServiceItemsuccess,
    TResult? Function(_DeleteServiceItemsuccess value)?
        deleteServiceItemsuccess,
    TResult? Function(_Failed value)? failed,
  }) {
    return updateServiceItemsuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_CustomerFetched value)? serviceItemsFetched,
    TResult Function(_CreateServiceItemsuccess value)? createServiceItemsuccess,
    TResult Function(_UpdateServiceItemsuccess value)? updateServiceItemsuccess,
    TResult Function(_DeleteServiceItemsuccess value)? deleteServiceItemsuccess,
    TResult Function(_Failed value)? failed,
    required TResult orElse(),
  }) {
    if (updateServiceItemsuccess != null) {
      return updateServiceItemsuccess(this);
    }
    return orElse();
  }
}

abstract class _UpdateServiceItemsuccess implements ServiceItemState {
  const factory _UpdateServiceItemsuccess({required final bool isSuccess}) =
      _$UpdateServiceItemsuccessImpl;

  bool get isSuccess;

  /// Create a copy of ServiceItemState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateServiceItemsuccessImplCopyWith<_$UpdateServiceItemsuccessImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeleteServiceItemsuccessImplCopyWith<$Res> {
  factory _$$DeleteServiceItemsuccessImplCopyWith(
          _$DeleteServiceItemsuccessImpl value,
          $Res Function(_$DeleteServiceItemsuccessImpl) then) =
      __$$DeleteServiceItemsuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool isSuccess});
}

/// @nodoc
class __$$DeleteServiceItemsuccessImplCopyWithImpl<$Res>
    extends _$ServiceItemStateCopyWithImpl<$Res, _$DeleteServiceItemsuccessImpl>
    implements _$$DeleteServiceItemsuccessImplCopyWith<$Res> {
  __$$DeleteServiceItemsuccessImplCopyWithImpl(
      _$DeleteServiceItemsuccessImpl _value,
      $Res Function(_$DeleteServiceItemsuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServiceItemState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSuccess = null,
  }) {
    return _then(_$DeleteServiceItemsuccessImpl(
      isSuccess: null == isSuccess
          ? _value.isSuccess
          : isSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$DeleteServiceItemsuccessImpl implements _DeleteServiceItemsuccess {
  const _$DeleteServiceItemsuccessImpl({required this.isSuccess});

  @override
  final bool isSuccess;

  @override
  String toString() {
    return 'ServiceItemState.deleteServiceItemsuccess(isSuccess: $isSuccess)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteServiceItemsuccessImpl &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isSuccess);

  /// Create a copy of ServiceItemState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteServiceItemsuccessImplCopyWith<_$DeleteServiceItemsuccessImpl>
      get copyWith => __$$DeleteServiceItemsuccessImplCopyWithImpl<
          _$DeleteServiceItemsuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ServiceItemEntity> serviceItems)
        serviceItemsFetched,
    required TResult Function(bool isSuccess) createServiceItemsuccess,
    required TResult Function(bool isSuccess) updateServiceItemsuccess,
    required TResult Function(bool isSuccess) deleteServiceItemsuccess,
    required TResult Function(String error) failed,
  }) {
    return deleteServiceItemsuccess(isSuccess);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ServiceItemEntity> serviceItems)?
        serviceItemsFetched,
    TResult? Function(bool isSuccess)? createServiceItemsuccess,
    TResult? Function(bool isSuccess)? updateServiceItemsuccess,
    TResult? Function(bool isSuccess)? deleteServiceItemsuccess,
    TResult? Function(String error)? failed,
  }) {
    return deleteServiceItemsuccess?.call(isSuccess);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ServiceItemEntity> serviceItems)? serviceItemsFetched,
    TResult Function(bool isSuccess)? createServiceItemsuccess,
    TResult Function(bool isSuccess)? updateServiceItemsuccess,
    TResult Function(bool isSuccess)? deleteServiceItemsuccess,
    TResult Function(String error)? failed,
    required TResult orElse(),
  }) {
    if (deleteServiceItemsuccess != null) {
      return deleteServiceItemsuccess(isSuccess);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_CustomerFetched value) serviceItemsFetched,
    required TResult Function(_CreateServiceItemsuccess value)
        createServiceItemsuccess,
    required TResult Function(_UpdateServiceItemsuccess value)
        updateServiceItemsuccess,
    required TResult Function(_DeleteServiceItemsuccess value)
        deleteServiceItemsuccess,
    required TResult Function(_Failed value) failed,
  }) {
    return deleteServiceItemsuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_CustomerFetched value)? serviceItemsFetched,
    TResult? Function(_CreateServiceItemsuccess value)?
        createServiceItemsuccess,
    TResult? Function(_UpdateServiceItemsuccess value)?
        updateServiceItemsuccess,
    TResult? Function(_DeleteServiceItemsuccess value)?
        deleteServiceItemsuccess,
    TResult? Function(_Failed value)? failed,
  }) {
    return deleteServiceItemsuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_CustomerFetched value)? serviceItemsFetched,
    TResult Function(_CreateServiceItemsuccess value)? createServiceItemsuccess,
    TResult Function(_UpdateServiceItemsuccess value)? updateServiceItemsuccess,
    TResult Function(_DeleteServiceItemsuccess value)? deleteServiceItemsuccess,
    TResult Function(_Failed value)? failed,
    required TResult orElse(),
  }) {
    if (deleteServiceItemsuccess != null) {
      return deleteServiceItemsuccess(this);
    }
    return orElse();
  }
}

abstract class _DeleteServiceItemsuccess implements ServiceItemState {
  const factory _DeleteServiceItemsuccess({required final bool isSuccess}) =
      _$DeleteServiceItemsuccessImpl;

  bool get isSuccess;

  /// Create a copy of ServiceItemState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteServiceItemsuccessImplCopyWith<_$DeleteServiceItemsuccessImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FailedImplCopyWith<$Res> {
  factory _$$FailedImplCopyWith(
          _$FailedImpl value, $Res Function(_$FailedImpl) then) =
      __$$FailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String error});
}

/// @nodoc
class __$$FailedImplCopyWithImpl<$Res>
    extends _$ServiceItemStateCopyWithImpl<$Res, _$FailedImpl>
    implements _$$FailedImplCopyWith<$Res> {
  __$$FailedImplCopyWithImpl(
      _$FailedImpl _value, $Res Function(_$FailedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServiceItemState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
  }) {
    return _then(_$FailedImpl(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FailedImpl implements _Failed {
  const _$FailedImpl({required this.error});

  @override
  final String error;

  @override
  String toString() {
    return 'ServiceItemState.failed(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FailedImpl &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of ServiceItemState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FailedImplCopyWith<_$FailedImpl> get copyWith =>
      __$$FailedImplCopyWithImpl<_$FailedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ServiceItemEntity> serviceItems)
        serviceItemsFetched,
    required TResult Function(bool isSuccess) createServiceItemsuccess,
    required TResult Function(bool isSuccess) updateServiceItemsuccess,
    required TResult Function(bool isSuccess) deleteServiceItemsuccess,
    required TResult Function(String error) failed,
  }) {
    return failed(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ServiceItemEntity> serviceItems)?
        serviceItemsFetched,
    TResult? Function(bool isSuccess)? createServiceItemsuccess,
    TResult? Function(bool isSuccess)? updateServiceItemsuccess,
    TResult? Function(bool isSuccess)? deleteServiceItemsuccess,
    TResult? Function(String error)? failed,
  }) {
    return failed?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ServiceItemEntity> serviceItems)? serviceItemsFetched,
    TResult Function(bool isSuccess)? createServiceItemsuccess,
    TResult Function(bool isSuccess)? updateServiceItemsuccess,
    TResult Function(bool isSuccess)? deleteServiceItemsuccess,
    TResult Function(String error)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_CustomerFetched value) serviceItemsFetched,
    required TResult Function(_CreateServiceItemsuccess value)
        createServiceItemsuccess,
    required TResult Function(_UpdateServiceItemsuccess value)
        updateServiceItemsuccess,
    required TResult Function(_DeleteServiceItemsuccess value)
        deleteServiceItemsuccess,
    required TResult Function(_Failed value) failed,
  }) {
    return failed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_CustomerFetched value)? serviceItemsFetched,
    TResult? Function(_CreateServiceItemsuccess value)?
        createServiceItemsuccess,
    TResult? Function(_UpdateServiceItemsuccess value)?
        updateServiceItemsuccess,
    TResult? Function(_DeleteServiceItemsuccess value)?
        deleteServiceItemsuccess,
    TResult? Function(_Failed value)? failed,
  }) {
    return failed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_CustomerFetched value)? serviceItemsFetched,
    TResult Function(_CreateServiceItemsuccess value)? createServiceItemsuccess,
    TResult Function(_UpdateServiceItemsuccess value)? updateServiceItemsuccess,
    TResult Function(_DeleteServiceItemsuccess value)? deleteServiceItemsuccess,
    TResult Function(_Failed value)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(this);
    }
    return orElse();
  }
}

abstract class _Failed implements ServiceItemState {
  const factory _Failed({required final String error}) = _$FailedImpl;

  String get error;

  /// Create a copy of ServiceItemState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FailedImplCopyWith<_$FailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
