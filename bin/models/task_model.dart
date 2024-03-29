import 'package:uuid/uuid.dart';

import '../core/enums/priority.dart';

class Task {
  String id;

  final String name;
  final String? description;
  final DateTime createdAt;
  DateTime? updateAt;
  final double estimate;
  final double completedWork;
  final bool complete;
  final Priority? priority;

  Task({
    this.description,
    required this.id,
    required this.name,
    required this.estimate,
    required this.createdAt,
    required this.completedWork,
    required this.updateAt,
    this.complete = false,
    this.priority,
  });

  factory Task.fromJson(dynamic json) {
    return Task(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] != null ?json['description'] as String : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      estimate: json['estimate'] as double,
      completedWork: json['completedWork'] as double,
      complete: json['complete'] as bool,
      updateAt: json['updateAt'] != null
          ? DateTime.parse(json['updateAt'] as String)
          : DateTime.parse(json['createdAt'] as String),
      priority: json['priority'] != null
          ? Priority.values[json['priority'] as int]
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.toString(),
      'estimate': estimate,
      'completedWork': completedWork,
      'complete': complete,
      'priority': priority?.index,
      'updateAt': updateAt.toString(),
    };
  }

  factory Task.newTask(dynamic json) {
    return Task(
      id: Uuid().v4(),
      name: json['name'] as String,
      description: json['description'] as String,
      createdAt: DateTime.now(),
      estimate: json['estimate'] != null ? json['estimate'] as double : 0,
      completedWork: 0,
      complete: false,
      priority: json['priority'] != null
          ? Priority.values[json['priority'] as int]
          : null,
      updateAt: DateTime.now(),
    );
  }
}
