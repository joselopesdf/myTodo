// lib/features/tasks/model/task_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

// gera o adapter com build_runner

part 'hive_task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String ownerId; // quem criou a task

  @HiveField(4)
  final List<String> assignedUserIds; // usuários responsáveis

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime? dueDate;

  @HiveField(7)
  final String priority; // "high", "medium", "low"

  @HiveField(8)
  final bool completed;

  @HiveField(9)
  final bool isSynced; // se a task está completa

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.ownerId,
    required this.assignedUserIds,
    required this.createdAt,
    this.dueDate,
    required this.priority,
    this.completed = false,
    this.isSynced = false,
  });

  // conversão para Map (Firebase)
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'ownerId': ownerId,
    'assignedUserIds': assignedUserIds,
    'createdAt': Timestamp.fromDate(createdAt), // ✅
    'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
    'priority': priority,
    'completed': completed,
  };

  // criação a partir de Map (Firebase)
  factory Task.fromMap(Map<String, dynamic> map, String id) => Task(
    isSynced: true,
    id: id,
    title: map['title'],
    description: map['description'],
    ownerId: map['ownerId'],
    assignedUserIds: List<String>.from(map['assignedUserIds']),
    createdAt: (map['createdAt'] as Timestamp).toDate(),
    dueDate: map['dueDate'] != null
        ? (map['dueDate'] as Timestamp).toDate()
        : null,
    priority: map['priority'],
    completed: map['completed'] ?? false,
  );

  // criar cópia com alteração (útil para toggle de completo)
  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? ownerId,
    List<String>? assignedUserIds,
    DateTime? createdAt,
    DateTime? dueDate,
    String? priority,
    bool? completed,
    bool? isSynced,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      assignedUserIds: assignedUserIds ?? this.assignedUserIds,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      completed: completed ?? this.completed,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
