// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_request.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PendingRequestAdapter extends TypeAdapter<PendingRequest> {
  @override
  final int typeId = 0;

  @override
  PendingRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PendingRequest(
      createdAt: fields[0] as DateTime,
      completedAt: fields[1] as DateTime?,
      processed: fields[2] as bool,
      url: fields[3] as String,
      body: (fields[4] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, PendingRequest obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.createdAt)
      ..writeByte(1)
      ..write(obj.completedAt)
      ..writeByte(2)
      ..write(obj.processed)
      ..writeByte(3)
      ..write(obj.url)
      ..writeByte(4)
      ..write(obj.body);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PendingRequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
