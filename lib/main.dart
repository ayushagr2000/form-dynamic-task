import 'package:flutter/material.dart';
import 'package:form_sync_project/services/hive/hive_helper.dart';
import 'package:get/get.dart';

import 'modules/dynamic_forms/view/form_screen.dart';
import 'services/connectivity/connectivity_controller.dart';

Future<void> main() async {
  //  final appDocumentDirectory = await getApplicationDocumentsDirectory();
    WidgetsFlutterBinding.ensureInitialized();

  HiveHelper.initHive();
     Get.put(ConnectivityController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
    
        primarySwatch: Colors.blue,
      ),
      home: FormScreen(),
    );
  }
}
