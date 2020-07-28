import 'package:connectivity/connectivity.dart';

class OnlineCheckBloc {

  bool isConnected;
  Connectivity checkConnectivity=Connectivity();

  checkInternetConnectivity() async {
    var result = await checkConnectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      isConnected=false;
    } else if (result == ConnectivityResult.mobile) {
      isConnected=true;
    } else if (result == ConnectivityResult.wifi) {
      isConnected=true;
    }
  }
}