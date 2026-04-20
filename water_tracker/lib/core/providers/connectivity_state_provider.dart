// Поток состояний сети (connectivity_plus).

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_state_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<List<ConnectivityResult>> connectivityStream(
  ConnectivityStreamRef ref,
) {
  return Connectivity().onConnectivityChanged;
}

/// true, если радио-модуль сообщает, что сеть в принципе доступна
bool isOnlineList(List<ConnectivityResult> r) {
  if (r.isEmpty) {
    return true;
  }
  if (r.length == 1 && r[0] == ConnectivityResult.none) {
    return false;
  }
  return r.any((ConnectivityResult c) => c != ConnectivityResult.none);
}

@Riverpod(keepAlive: true)
Future<bool> isOnlineNow(IsOnlineNowRef ref) async {
  return isOnlineList(await Connectivity().checkConnectivity());
}
