// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$waterRepositoryHash() => r'39391c0a000ff50c9f7c4cf56f9ff18c2e365842';

/// See also [waterRepository].
@ProviderFor(waterRepository)
final waterRepositoryProvider = AutoDisposeProvider<WaterRepository>.internal(
  waterRepository,
  name: r'waterRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$waterRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WaterRepositoryRef = AutoDisposeProviderRef<WaterRepository>;
String _$todayTotalHash() => r'53218758fa4353908c058e2b38faf1933437baf7';

/// See also [todayTotal].
@ProviderFor(todayTotal)
final todayTotalProvider = AutoDisposeProvider<int>.internal(
  todayTotal,
  name: r'todayTotalProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayTotalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayTotalRef = AutoDisposeProviderRef<int>;
String _$dailyWaterGoalHash() => r'fa72f93951d34bfbafdb86ecf77957511b55ebd5';

/// See also [dailyWaterGoal].
@ProviderFor(dailyWaterGoal)
final dailyWaterGoalProvider = AutoDisposeFutureProvider<int>.internal(
  dailyWaterGoal,
  name: r'dailyWaterGoalProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dailyWaterGoalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailyWaterGoalRef = AutoDisposeFutureProviderRef<int>;
String _$todayIntakesHash() => r'6862b7c9ec52affc67e6fe2186fd398b5135cd02';

/// See also [TodayIntakes].
@ProviderFor(TodayIntakes)
final todayIntakesProvider =
    AutoDisposeAsyncNotifierProvider<TodayIntakes, List<WaterIntake>>.internal(
      TodayIntakes.new,
      name: r'todayIntakesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todayIntakesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TodayIntakes = AutoDisposeAsyncNotifier<List<WaterIntake>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
