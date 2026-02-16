// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 1;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      ownerId: fields[3] as String,
      assignedUserIds: (fields[4] as List).cast<String>(),
      createdAt: fields[5] as DateTime,
      dueDate: fields[6] as DateTime?,
      priority: fields[7] as String,
      completed: fields[8] as bool,
      isSynced: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.ownerId)
      ..writeByte(4)
      ..write(obj.assignedUserIds)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.dueDate)
      ..writeByte(7)
      ..write(obj.priority)
      ..writeByte(8)
      ..write(obj.completed)
      ..writeByte(9)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
