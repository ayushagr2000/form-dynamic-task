import 'package:hive/hive.dart';

part 'workmanager_task_entry.g.dart';

@HiveType(typeId: 1)
class WorkManagerTaskList {
  @HiveField(0)
  final DateTime executedAt;

  WorkManagerTaskList({
    required this.executedAt,
  });

}