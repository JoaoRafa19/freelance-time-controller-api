import 'package:sembast/sembast.dart';

import '../core/enums/project_status.dart';
import 'task_model.dart';

class Project {
  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.ownerId,
    this.status = ProjectStatus.emAndamento,
    this.tasks = const [],
  });

  final String name;
  final String description;
  final String id;
  final String ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  
  final ProjectStatus status;
  final List<Task> tasks;

  factory Project.fromJson(RecordSnapshot json) {
    final project = Project(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String) ,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      ownerId: json['ownerId'] as String,
      status: ProjectStatus.values[json['status'] as int],
      tasks: json['tasks'] != null ? (json['tasks'] as List).map((task) {
        return Task.fromJson(task ) ;
      }).toList() : [],
    );
    return project;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
      'ownerId': ownerId,
      'status': status.index,
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }

  factory Project.newProject(
      String ownerId, String name, String description, String id) {
    return Project(
      id: id,
      name: name,
      description: description,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      ownerId: ownerId,
      status: ProjectStatus.emAndamento,
      tasks: [],
    );
  }
}
