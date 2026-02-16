import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final String ownerId;
  final List<String> assignedUsers;
  final bool completed;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime dueDate;
  final String priority;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.ownerId,
    required this.assignedUsers,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
    required this.dueDate,
    required this.priority,
  });

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'ownerId': ownerId,
    'assignedUsers': assignedUsers,
    'completed': completed,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'dueDate': dueDate.toIso8601String(),
    'priority': priority,
  };

  factory Task.fromMap(String id, Map<String, dynamic> map) => Task(
    id: id,
    title: map['title'],
    description: map['description'],
    ownerId: map['ownerId'],
    assignedUsers: List<String>.from(map['assignedUsers'] ?? []),
    completed: map['completed'] ?? false,
    createdAt: DateTime.parse(map['createdAt']),
    updatedAt: DateTime.parse(map['updatedAt']),
    dueDate: DateTime.parse(map['dueDate']),
    priority: map['priority'] ?? 'normal',
  );
}
