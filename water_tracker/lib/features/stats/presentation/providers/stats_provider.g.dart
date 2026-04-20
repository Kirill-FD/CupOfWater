// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$statsRepositoryHash() => r'9e8a7b6c5d4e3f2a1b0c9d8e7f6a5b4c3d2e1f0';

/// See also [statsRepository].
@ProviderFor(statsRepository)
final statsRepositoryProvider = AutoDisposeProvider<StatsRepository>.internal(
  statsRepository,
  name: r'statsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$statsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StatsRepositoryRef = AutoDisposeProviderRef<StatsRepository>;
String _$weeklyStatsHash() => r'1a2b3c4d5e6f708192a3b4c5d6e7f8091a2b3c4d';

/// See also [weeklyStats].
@ProviderFor(weeklyStats)
final weeklyStatsProvider =
    AutoDisposeFutureProvider<Map<DateTime, int>>.internal(
  weeklyStats,
  name: r'weeklyStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weeklyStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeeklyStatsRef = AutoDisposeFutureProviderRef<Map<DateTime, int>>;
String _$monthlyStatsHash() => r'2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1';

/// See also [monthlyStats].
@ProviderFor(monthlyStats)
final monthlyStatsProvider =
    AutoDisposeFutureProvider<Map<DateTime, int>>.internal(
  monthlyStats,
  name: r'monthlyStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$monthlyStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MonthlyStatsRef = AutoDisposeFutureProviderRef<Map<DateTime, int>>;
String _$currentStreakHash() => r'3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2';

/// See also [currentStreak].
@ProviderFor(currentStreak)
final currentStreakProvider = AutoDisposeFutureProvider<int>.internal(
  currentStreak,
  name: r'currentStreakProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentStreakHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentStreakRef = AutoDisposeFutureProviderRef<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
