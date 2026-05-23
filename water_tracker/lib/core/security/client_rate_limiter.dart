class RateLimitResult {
  const RateLimitResult({
    required this.allowed,
    this.retryAfter = Duration.zero,
  });

  final bool allowed;
  final Duration retryAfter;
}

/// Lightweight in-memory limiter for sensitive client actions.
///
/// Important: this is a UX/abuse mitigation layer on the client.
/// Real security limits must also be enforced on backend/Supabase side.
class ClientRateLimiter {
  ClientRateLimiter._();

  static final ClientRateLimiter instance = ClientRateLimiter._();

  final Map<String, List<DateTime>> _hits = <String, List<DateTime>>{};

  RateLimitResult consume(
    String key, {
    required int maxAttempts,
    required Duration window,
  }) {
    final DateTime now = DateTime.now();
    final DateTime edge = now.subtract(window);
    final List<DateTime> list =
        (_hits[key] ?? <DateTime>[]).where((DateTime t) => t.isAfter(edge)).toList();

    if (list.length >= maxAttempts) {
      final DateTime first = list.first;
      final Duration retryAfter = first.add(window).difference(now);
      _hits[key] = list;
      return RateLimitResult(
        allowed: false,
        retryAfter: retryAfter.isNegative ? Duration.zero : retryAfter,
      );
    }

    list.add(now);
    _hits[key] = list;
    return const RateLimitResult(allowed: true);
  }

  void reset(String key) {
    _hits.remove(key);
  }
}
