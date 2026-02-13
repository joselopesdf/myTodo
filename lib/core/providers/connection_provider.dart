import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Provider global que emite o estado de conexão em tempo real
final connectivityStatusProvider = StreamProvider<ConnectivityResult>((ref) {
  final connectivity = Connectivity();

  // Converte Stream<List<ConnectivityResult>> → Stream<ConnectivityResult>
  return connectivity.onConnectivityChanged.map(
    (list) => list.isNotEmpty ? list.first : ConnectivityResult.none,
  );
});

/// Provider helper que retorna true se o usuário estiver online
final isOnlineProvider = Provider<bool>((ref) {
  final status = ref.watch(connectivityStatusProvider).asData?.value;
  return status != null && status != ConnectivityResult.none;
});
