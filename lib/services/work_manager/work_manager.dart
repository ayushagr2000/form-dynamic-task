

import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';

import '../connectivity/connectivity_controller.dart';
import '../hive/hive_helper.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
   await HiveHelper.initHive();
   if (Get.isRegistered<ConnectivityController>()) {
    print('ConnectivityController already initialized');
  } else {
    Get.put(ConnectivityController());
    print('ConnectivityController initialized');
  }
     HiveHelper.processPendingRequestIfAny();
     HiveHelper.addExecutionList();

    return Future.value(true);
  });
}