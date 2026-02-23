import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/throttle.dart';

final throttleProvider = Provider(
  (ref) => Throttler(duration: const Duration(seconds: 1)),
);
