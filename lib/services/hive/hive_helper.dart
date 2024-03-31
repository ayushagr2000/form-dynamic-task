import 'package:form_sync_project/services/API/api_services.dart';
import 'package:form_sync_project/services/hive/models/workmanager_task_entry.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/pending_request.dart';

class HiveHelper {
  static const String pendingRequestBox = 'pendingRequests';
  static const String taskExecutionList = 'taskExecutionList';

  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PendingRequestAdapter());
    Hive.registerAdapter(WorkManagerTaskListAdapter());
    await Hive.openBox<PendingRequest>(pendingRequestBox);
    await Hive.openBox<WorkManagerTaskList>(taskExecutionList);
  }

  static Future<void> addPendingRequest(
      String url, Map<String, dynamic> body) async {
    final box = await Hive.box<PendingRequest>(pendingRequestBox);
    await box.add(PendingRequest(
      createdAt: DateTime.now(),
      processed: false,
      url: url,
      body: body,
    ));
    getPendingRequests();
  }

  static Future<void> addExecutionList() async {
    final box = Hive.box<WorkManagerTaskList>(taskExecutionList);
    await box.add(WorkManagerTaskList(executedAt: DateTime.now()));
    getRecentExecutionList();
  }

  static Future<List<WorkManagerTaskList>> getRecentExecutionList() async {
    final box = Hive.box<WorkManagerTaskList>(taskExecutionList);
    print(box.values.toList());
    for (int i = 0; i < box.values.length; i++) {
      var element = box.values.elementAt(i);
      print(element.executedAt.toString());
    }
    return box.values.toList();
  }

  static Future<List<PendingRequest>> getPendingRequests() async {
    final box = Hive.box<PendingRequest>(pendingRequestBox);
    print(box.values.toList());
    for (int i = 0; i < box.values.length; i++) {
      var element = box.values.elementAt(i);
      print(element.toJson().toString());
      print("-----------------");
    }
    return box.values.toList();
  }

  static Future<List<PendingRequest>> processPendingRequestIfAny() async {
    final box = Hive.box<PendingRequest>(pendingRequestBox);

    for (int i = 0; i < box.values.length; i++) {
      var element = box.values.elementAt(i);
      if (!element.processed) {
        ApiService.submitResponse(element.body);
        markRequestProcessed(i);
      }
    }

    return box.values.toList();
  }

  static Future<void> markRequestProcessed(int index) async {
    final box = Hive.box<PendingRequest>(pendingRequestBox);
    final request = box.getAt(index);
    if (request != null) {
      PendingRequest updateRequest = PendingRequest(
          createdAt: request.createdAt,
          processed: true,
          url: request.url,
          body: request.body,
          completedAt: DateTime.now());
      await box.putAt(index, updateRequest);
    }
  }

  static Future<void> clearAllOlderHistory() async {
    await Future.wait([
      Hive.box<PendingRequest>(pendingRequestBox).clear(),
      Hive.box<WorkManagerTaskList>(taskExecutionList).clear()
    ]);
  }
}
