import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:postgrest/postgrest.dart';

/// PostgREST builders реализуют [Future]; для тестов нужен объект правильного
/// статического типа, а не приведение [Future] к builder.
class AwaitablePostgrestMap extends Fake implements PostgrestTransformBuilder<PostgrestMap> {
  AwaitablePostgrestMap(this._value);
  final PostgrestMap _value;

  Future<PostgrestMap> get _f => Future<PostgrestMap>.value(_value);

  @override
  Stream<PostgrestMap> asStream() => _f.asStream();

  @override
  Future<PostgrestMap> catchError(
    Function onError, {
    bool Function(Object error)? test,
  }) =>
      _f.catchError(onError, test: test);

  @override
  Future<R> then<R>(
    FutureOr<R> Function(PostgrestMap value) onValue, {
    Function? onError,
  }) =>
      _f.then(onValue, onError: onError);

  @override
  Future<PostgrestMap> timeout(
    Duration timeLimit, {
    FutureOr<PostgrestMap> Function()? onTimeout,
  }) =>
      _f.timeout(timeLimit, onTimeout: onTimeout);

  @override
  Future<PostgrestMap> whenComplete(FutureOr<void> Function()? action) =>
      _f.whenComplete(action ?? () {});
}

class AwaitableDynamic extends Fake implements PostgrestFilterBuilder<dynamic> {
  AwaitableDynamic(this._value);
  final dynamic _value;

  Future<dynamic> get _f => Future<dynamic>.value(_value);

  @override
  Stream<dynamic> asStream() => _f.asStream();

  @override
  Future<dynamic> catchError(
    Function onError, {
    bool Function(Object error)? test,
  }) =>
      _f.catchError(onError, test: test);

  @override
  Future<R> then<R>(
    FutureOr<R> Function(dynamic value) onValue, {
    Function? onError,
  }) =>
      _f.then(onValue, onError: onError);

  @override
  Future<dynamic> timeout(
    Duration timeLimit, {
    FutureOr<dynamic> Function()? onTimeout,
  }) =>
      _f.timeout(timeLimit, onTimeout: onTimeout);

  @override
  Future<dynamic> whenComplete(FutureOr<void> Function()? action) =>
      _f.whenComplete(action ?? () {});
}

/// Цепочка `delete().eq()` в тестах завершается значением `null`.
class AwaitableDeleteDone extends Fake implements PostgrestFilterBuilder<dynamic> {
  Future<dynamic> get _f => Future<dynamic>.value(null);

  @override
  Stream<dynamic> asStream() => _f.asStream();

  @override
  Future<dynamic> catchError(
    Function onError, {
    bool Function(Object error)? test,
  }) =>
      _f.catchError(onError, test: test);

  @override
  Future<R> then<R>(
    FutureOr<R> Function(dynamic value) onValue, {
    Function? onError,
  }) =>
      _f.then(onValue, onError: onError);

  @override
  Future<dynamic> timeout(
    Duration timeLimit, {
    FutureOr<dynamic> Function()? onTimeout,
  }) =>
      _f.timeout(timeLimit, onTimeout: onTimeout);

  @override
  Future<dynamic> whenComplete(FutureOr<void> Function()? action) =>
      _f.whenComplete(action ?? () {});
}
