// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workmanager_task_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkManagerTaskListAdapter extends TypeAdapter<WorkManagerTaskList> {
  @override
  final int typeId = 1;

  @override
  WorkManagerTaskList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkManagerTaskList(
      executedAt: fields[0] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WorkManagerTaskList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.executedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkManagerTaskListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
