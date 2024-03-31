import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:form_sync_project/services/hive/hive_helper.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  ConnectivityResult? _connectivityResult;

  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_onConnectivityChange);
    checkConnectivity();
    
  }

  @override
  void onClose() {
    super.onClose();
    _connectivitySubscription?.cancel();
  }

  Future<ConnectivityResult?> checkConnectivity() async {
    _connectivityResult = await _connectivity.checkConnectivity();
         update();
         return _connectivityResult;
  }

  void _onConnectivityChange(ConnectivityResult result) {
    _connectivityResult = result;
    if(isConnected){
 HiveHelper.processPendingRequestIfAny();
    }
   
         print("ConnectivityController:  network change " + _connectivityResult.toString()); 
    update(); 
  }

  bool get isConnected => _connectivityResult == ConnectivityResult.mobile || _connectivityResult == ConnectivityResult.wifi;
}