import 'package:flutter/material.dart';
import 'package:form_sync_project/services/hive/hive_helper.dart';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';
import 'modules/dynamic_forms/view/screens/form_screen.dart';
import 'services/connectivity/connectivity_controller.dart';
import 'services/work_manager/work_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerPeriodicTask("task-lll", "simpleTaskLLL").then((value) {
    print("Task scheduled successfully");
  });
  await HiveHelper.initHive();
  Get.put(ConnectivityController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Polaris Assignment App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FormScreen(),
    );
  }
}
