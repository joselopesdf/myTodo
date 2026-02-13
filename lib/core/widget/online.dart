import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../providers/connection_provider.dart';

/// Widget que mostra uma bolinha verde/vermelha conforme internet
class ConnectionStatusDot extends ConsumerWidget {
  final double size;

  const ConnectionStatusDot({super.key, this.size = 12});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isOnline ? Colors.green : Colors.red,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white, // opcional, deixa a bolinha destacada
          width: 1.5,
        ),
      ),
    );
  }
}
