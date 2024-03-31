import 'package:form_sync_project/services/API/api_services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/pending_request.dart';

class HiveHelper {
  static const String pendingRequestBox = 'pendingRequests';

  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PendingRequestAdapter());
    await Hive.openBox<PendingRequest>(pendingRequestBox);
  }

  static Future<void> addPendingRequest(String url, Map<String, dynamic> body) async {
    final box = await Hive.box<PendingRequest>(pendingRequestBox);
   var dd = await box.add(PendingRequest(
      createdAt: DateTime.now(),
      processed: false,
      url: url,
      body: body,
    ));
    getPendingRequests();
    // print(dd);
  }

  static Future<List<PendingRequest>> getPendingRequests() async {
    final box = await Hive.box<PendingRequest>(pendingRequestBox);
    print(box.values.toList());
    for (int i=0;i<box.values.length;i++) {
      var element = box.values.elementAt(i);
      print(element.toJson().toString());
         print("-----------------");
    }
    return box.values.toList();
  }

    static Future<List<PendingRequest>> processPendingRequestIfAny() async {
    final box = await Hive.box<PendingRequest>(pendingRequestBox);
    print(box.values.toList());

      for (int i=0;i<box.values.length;i++) {
      var element = box.values.elementAt(i);
     if(!element.processed){
        ApiService.submitResponse(element.body);
        markRequestProcessed(i);

      }
      print(element);
    }
  
    return box.values.toList();
  }

  static Future<void> markRequestProcessed(int index) async {
    final box =  Hive.box<PendingRequest>(pendingRequestBox);
    final request = box.getAt(index);
    if (request != null) {
      PendingRequest updateRequest = PendingRequest(createdAt: request.createdAt, processed: true, url: request.url, body: request.body,completedAt: DateTime.now()); 
      await box.putAt(index, updateRequest);
    }
  }

  Future<void> clearProcessedRequests() async {
    final box = await Hive.box<PendingRequest>(pendingRequestBox);
    // await box.deleteWhere((key, value) => value.processed);
  }
}