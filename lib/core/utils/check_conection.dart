import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> isOnline() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  // Considera online se estiver conectado por wifi ou celular
  return connectivityResult == ConnectivityResult.wifi ||
      connectivityResult == ConnectivityResult.mobile;
}
