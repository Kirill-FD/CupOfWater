// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$connectivityStreamHash() =>
    r'8b7c6d5e4f3a2b1c0d9e8f7a6b5c4d3e2f1a0b9c8';

@ProviderFor(connectivityStream)
final StreamProvider<List<ConnectivityResult>> connectivityStreamProvider =
    StreamProvider<List<ConnectivityResult>>.internal(
  connectivityStream,
  name: r'connectivityStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$connectivityStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConnectivityStreamRef = StreamProviderRef<List<ConnectivityResult>>;

String _$isOnlineNowHash() => r'7a6b5c4d3e2f1a0b9c8d7e6f5a4b3c2d1e0f9a8b7';

@ProviderFor(isOnlineNow)
final FutureProvider<bool> isOnlineNowProvider = FutureProvider<bool>.internal(
  isOnlineNow,
  name: r'isOnlineNowProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isOnlineNowHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsOnlineNowRef = FutureProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
