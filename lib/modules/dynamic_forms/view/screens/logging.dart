
import 'package:flutter/material.dart';
import 'package:form_sync_project/services/hive/models/workmanager_task_entry.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../services/hive/hive_helper.dart';
import '../../../../services/hive/models/pending_request.dart';


class PendingRequestsList extends StatelessWidget {
  const PendingRequestsList({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Logs"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Pending Requests"),
              Tab(text: "Background Tasks"),
            ],
          ),
          actions: [
            ElevatedButton(onPressed: (){
              HiveHelper.clearAllOlderHistory();
            }, child: const Text('Clear'))
          ],
        ),
        body: const TabBarView(
          children: [
            PendingRequestsTab(),
            TaskExecutionListTab(),
          ],
        ),
      ),
    );
  }
}

class PendingRequestsTab extends StatelessWidget {
  const PendingRequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<PendingRequest>(HiveHelper.pendingRequestBox);

    return SingleChildScrollView(
      child: ValueListenableBuilder<Box<PendingRequest>>(
        valueListenable: box.listenable(),
        builder: (context, box, child) {
          final pendingRequests = box.values.toList();
          if (pendingRequests.isEmpty) {
            return Container(
              height: 400,
              child: const Center(child: Text('No pending requests')));
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pendingRequests.length,
            itemBuilder: (context, index) {
              final request = pendingRequests[index];
              return ListTile(
                title: Text(request.processed.toString()),
                subtitle: Text(
                    'Created at: ${request.createdAt.toString()} and executed at ${request.completedAt}'),
                trailing: request.processed
                    ? const Icon(Icons.check, color: Colors.green)
                    : const Icon(Icons.access_time, color: Colors.amber),
              );
            },
          );
        },
      ),
    );
  }
}

class TaskExecutionListTab extends StatelessWidget {
  const TaskExecutionListTab({super.key});

  @override
  Widget build(BuildContext context) {
        final box = Hive.box<WorkManagerTaskList>(HiveHelper.taskExecutionList);

return SingleChildScrollView(
      child: ValueListenableBuilder<Box<WorkManagerTaskList>>(
        valueListenable: box.listenable(),
        builder: (context, box, child) {
          final executionList = box.values.toList();
          if (executionList.isEmpty) {
            return const SizedBox(
              height: 400,
              child: Center(child: Text('No execution data')));
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: executionList.length,
            itemBuilder: (context, index) {
              final execution = executionList[index];
              return ListTile(
                title: Text(execution.executedAt.toString()),
              );
            },
          );
        },
      ),
    );
  }
}
