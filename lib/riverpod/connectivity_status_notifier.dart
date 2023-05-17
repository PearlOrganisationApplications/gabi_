import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectivityStatus { NotDetermined, isConnected, isDisonnected }

// Final Global Variable which will expose the state.
// Should be outside of the class.
final connectivityStatusProviders = StateNotifierProvider((ref) {
  /*networkStatusNotifier.checkConnectivity();
  networkStatusNotifier.startMonitoring();*/
  return ConnectivityStatusNotifier();
});


class ConnectivityStatusNotifier extends StateNotifier<ConnectivityStatus> {
  ConnectivityStatus? lastResult;
  ConnectivityStatus? newState;

  ConnectivityStatusNotifier() : super(ConnectivityStatus.isConnected) {
    if (state == ConnectivityStatus.isConnected) {
      lastResult = ConnectivityStatus.isConnected;
    } else {
      lastResult = ConnectivityStatus.isDisonnected;
    }
    lastResult = ConnectivityStatus.NotDetermined;
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(lastResult == ConnectivityStatus.isDisonnected){
        EasyLoading.showSuccess('Connected to Internet');
      }
      if(lastResult == ConnectivityStatus.isConnected){
        EasyLoading.showError('No Internet!');
      }

      switch (result) {
        case ConnectivityResult.mobile:
        case ConnectivityResult.wifi:
          newState = ConnectivityStatus.isConnected;
          break;
        case ConnectivityResult.none:
          newState = ConnectivityStatus.isDisonnected;
          break;
      }
      if (newState != lastResult) {
        state = newState!;
        lastResult = newState;
      }
    });
  }
}



