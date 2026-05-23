// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$statsRepositoryHash() => r'412f72772ecc3dc4400ee6e52127a39bd7fa3a9e';

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
String _$weeklyStatsHash() => r'a5b8798f0dd30f95f3a0e0671e1ee90081050f0d';

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
String _$monthlyStatsHash() => r'14682cc48892c6f1d6c22a8a7425907eb2e6681b';

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
String _$currentStreakHash() => r'b2908e14ab7758e4839c2c9d8d052f73033e705f';

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
String _$calendarMonthStatsHash() =>
    r'59c1077e4b9013e2c1fa794709e76f18e2f84b5c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [calendarMonthStats].
@ProviderFor(calendarMonthStats)
const calendarMonthStatsProvider = CalendarMonthStatsFamily();

/// See also [calendarMonthStats].
class CalendarMonthStatsFamily extends Family<AsyncValue<Map<DateTime, int>>> {
  /// See also [calendarMonthStats].
  const CalendarMonthStatsFamily();

  /// See also [calendarMonthStats].
  CalendarMonthStatsProvider call(int year, int month) {
    return CalendarMonthStatsProvider(year, month);
  }

  @override
  CalendarMonthStatsProvider getProviderOverride(
    covariant CalendarMonthStatsProvider provider,
  ) {
    return call(provider.year, provider.month);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'calendarMonthStatsProvider';
}

/// See also [calendarMonthStats].
class CalendarMonthStatsProvider
    extends AutoDisposeFutureProvider<Map<DateTime, int>> {
  /// See also [calendarMonthStats].
  CalendarMonthStatsProvider(int year, int month)
    : this._internal(
        (ref) => calendarMonthStats(ref as CalendarMonthStatsRef, year, month),
        from: calendarMonthStatsProvider,
        name: r'calendarMonthStatsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$calendarMonthStatsHash,
        dependencies: CalendarMonthStatsFamily._dependencies,
        allTransitiveDependencies:
            CalendarMonthStatsFamily._allTransitiveDependencies,
        year: year,
        month: month,
      );

  CalendarMonthStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.month,
  }) : super.internal();

  final int year;
  final int month;

  @override
  Override overrideWith(
    FutureOr<Map<DateTime, int>> Function(CalendarMonthStatsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CalendarMonthStatsProvider._internal(
        (ref) => create(ref as CalendarMonthStatsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<DateTime, int>> createElement() {
    return _CalendarMonthStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CalendarMonthStatsProvider &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CalendarMonthStatsRef
    on AutoDisposeFutureProviderRef<Map<DateTime, int>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _CalendarMonthStatsProviderElement
    extends AutoDisposeFutureProviderElement<Map<DateTime, int>>
    with CalendarMonthStatsRef {
  _CalendarMonthStatsProviderElement(super.provider);

  @override
  int get year => (origin as CalendarMonthStatsProvider).year;
  @override
  int get month => (origin as CalendarMonthStatsProvider).month;
}

String _$yearlyMonthlyTotalsHash() =>
    r'8dee662e47306c63d8db497eeb2530891b96c974';

/// See also [yearlyMonthlyTotals].
@ProviderFor(yearlyMonthlyTotals)
const yearlyMonthlyTotalsProvider = YearlyMonthlyTotalsFamily();

/// See also [yearlyMonthlyTotals].
class YearlyMonthlyTotalsFamily extends Family<AsyncValue<Map<int, int>>> {
  /// See also [yearlyMonthlyTotals].
  const YearlyMonthlyTotalsFamily();

  /// See also [yearlyMonthlyTotals].
  YearlyMonthlyTotalsProvider call(int year) {
    return YearlyMonthlyTotalsProvider(year);
  }

  @override
  YearlyMonthlyTotalsProvider getProviderOverride(
    covariant YearlyMonthlyTotalsProvider provider,
  ) {
    return call(provider.year);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'yearlyMonthlyTotalsProvider';
}

/// See also [yearlyMonthlyTotals].
class YearlyMonthlyTotalsProvider
    extends AutoDisposeFutureProvider<Map<int, int>> {
  /// See also [yearlyMonthlyTotals].
  YearlyMonthlyTotalsProvider(int year)
    : this._internal(
        (ref) => yearlyMonthlyTotals(ref as YearlyMonthlyTotalsRef, year),
        from: yearlyMonthlyTotalsProvider,
        name: r'yearlyMonthlyTotalsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$yearlyMonthlyTotalsHash,
        dependencies: YearlyMonthlyTotalsFamily._dependencies,
        allTransitiveDependencies:
            YearlyMonthlyTotalsFamily._allTransitiveDependencies,
        year: year,
      );

  YearlyMonthlyTotalsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
  }) : super.internal();

  final int year;

  @override
  Override overrideWith(
    FutureOr<Map<int, int>> Function(YearlyMonthlyTotalsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: YearlyMonthlyTotalsProvider._internal(
        (ref) => create(ref as YearlyMonthlyTotalsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<int, int>> createElement() {
    return _YearlyMonthlyTotalsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is YearlyMonthlyTotalsProvider && other.year == year;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin YearlyMonthlyTotalsRef on AutoDisposeFutureProviderRef<Map<int, int>> {
  /// The parameter `year` of this provider.
  int get year;
}

class _YearlyMonthlyTotalsProviderElement
    extends AutoDisposeFutureProviderElement<Map<int, int>>
    with YearlyMonthlyTotalsRef {
  _YearlyMonthlyTotalsProviderElement(super.provider);

  @override
  int get year => (origin as YearlyMonthlyTotalsProvider).year;
}

String _$weekOverWeekAveragesHash() =>
    r'78f93ffc380658f8b05442b42a9c74815545f42a';

/// Средние за текущую и предыдущую недели (7 дней).
///
/// Copied from [weekOverWeekAverages].
@ProviderFor(weekOverWeekAverages)
final weekOverWeekAveragesProvider =
    AutoDisposeFutureProvider<
      ({double currentAvg, double previousAvg})
    >.internal(
      weekOverWeekAverages,
      name: r'weekOverWeekAveragesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$weekOverWeekAveragesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeekOverWeekAveragesRef =
    AutoDisposeFutureProviderRef<({double currentAvg, double previousAvg})>;
String _$profileRollingYearStatsHash() =>
    r'f8b0ffa450cc4a7c42d58217fc9074e56092db7d';

/// Сумма и дни с записью за последние ~365 дней (блок «профиль»).
///
/// Copied from [profileRollingYearStats].
@ProviderFor(profileRollingYearStats)
final profileRollingYearStatsProvider =
    AutoDisposeFutureProvider<({int sumMl, int activeDays})>.internal(
      profileRollingYearStats,
      name: r'profileRollingYearStatsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$profileRollingYearStatsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfileRollingYearStatsRef =
    AutoDisposeFutureProviderRef<({int sumMl, int activeDays})>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
