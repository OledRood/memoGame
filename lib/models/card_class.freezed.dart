// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_class.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CardClass {
  String get content => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  bool get isFace => throw _privateConstructorUsedError;
  bool get isGuessed => throw _privateConstructorUsedError;

  /// Create a copy of CardClass
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CardClassCopyWith<CardClass> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CardClassCopyWith<$Res> {
  factory $CardClassCopyWith(CardClass value, $Res Function(CardClass) then) =
      _$CardClassCopyWithImpl<$Res, CardClass>;
  @useResult
  $Res call({String content, String id, bool isFace, bool isGuessed});
}

/// @nodoc
class _$CardClassCopyWithImpl<$Res, $Val extends CardClass>
    implements $CardClassCopyWith<$Res> {
  _$CardClassCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CardClass
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? id = null,
    Object? isFace = null,
    Object? isGuessed = null,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      isFace: null == isFace
          ? _value.isFace
          : isFace // ignore: cast_nullable_to_non_nullable
              as bool,
      isGuessed: null == isGuessed
          ? _value.isGuessed
          : isGuessed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CardClassImplCopyWith<$Res>
    implements $CardClassCopyWith<$Res> {
  factory _$$CardClassImplCopyWith(
          _$CardClassImpl value, $Res Function(_$CardClassImpl) then) =
      __$$CardClassImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String content, String id, bool isFace, bool isGuessed});
}

/// @nodoc
class __$$CardClassImplCopyWithImpl<$Res>
    extends _$CardClassCopyWithImpl<$Res, _$CardClassImpl>
    implements _$$CardClassImplCopyWith<$Res> {
  __$$CardClassImplCopyWithImpl(
      _$CardClassImpl _value, $Res Function(_$CardClassImpl) _then)
      : super(_value, _then);

  /// Create a copy of CardClass
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? id = null,
    Object? isFace = null,
    Object? isGuessed = null,
  }) {
    return _then(_$CardClassImpl(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      isFace: null == isFace
          ? _value.isFace
          : isFace // ignore: cast_nullable_to_non_nullable
              as bool,
      isGuessed: null == isGuessed
          ? _value.isGuessed
          : isGuessed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$CardClassImpl extends _CardClass {
  const _$CardClassImpl(
      {required this.content,
      required this.id,
      this.isFace = false,
      this.isGuessed = false})
      : super._();

  @override
  final String content;
  @override
  final String id;
  @override
  @JsonKey()
  final bool isFace;
  @override
  @JsonKey()
  final bool isGuessed;

  @override
  String toString() {
    return 'CardClass(content: $content, id: $id, isFace: $isFace, isGuessed: $isGuessed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CardClassImpl &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.isFace, isFace) || other.isFace == isFace) &&
            (identical(other.isGuessed, isGuessed) ||
                other.isGuessed == isGuessed));
  }

  @override
  int get hashCode => Object.hash(runtimeType, content, id, isFace, isGuessed);

  /// Create a copy of CardClass
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CardClassImplCopyWith<_$CardClassImpl> get copyWith =>
      __$$CardClassImplCopyWithImpl<_$CardClassImpl>(this, _$identity);
}

abstract class _CardClass extends CardClass {
  const factory _CardClass(
      {required final String content,
      required final String id,
      final bool isFace,
      final bool isGuessed}) = _$CardClassImpl;
  const _CardClass._() : super._();

  @override
  String get content;
  @override
  String get id;
  @override
  bool get isFace;
  @override
  bool get isGuessed;

  /// Create a copy of CardClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CardClassImplCopyWith<_$CardClassImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
