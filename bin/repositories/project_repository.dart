import 'dart:convert';

import 'package:sembast/sembast.dart';
import 'package:shelf/shelf.dart';
import '../core/database/database.dart' as _db;
import '../models/project_model.dart';

class ProjectRepository {
  static final ProjectRepository instance = ProjectRepository._internal();
  factory ProjectRepository() => instance;
  ProjectRepository._internal();

  static const String _collectionName = 'projects';

  StoreRef storeRef = StoreRef(_collectionName);

  /// ### Create
  /// - This method is responsible for create a new project.
  /// - This method is async.
  ///
  /// ##### Parameters:
  ///  * `Project project`: Project model.
  ///
  /// #### exemple:
  ///
  /// ```dart
  ///  await ProjectRepository.instance.create(project);
  /// ```
  ///
  Future<Response> create(Project project) async {
    try {
      final db = await _db.Database().openConnection();

      await storeRef.add(db, project.toJson());
      return Response.ok(jsonEncode(project));
    } catch (e) {
      rethrow;
    }
  }

  /// #### Update
  /// - This method is responsible for update a project.
  ///
  /// ##### Parameters:
  /// * `Project project`: Project model.
  ///
  /// #### exemple:
  /// ```dart
  ///   final project = await ProjectRepository.instance.findById(id)
  ///   ..name = 'new name';
  ///   await ProjectRepository.instance.update(project);
  /// ```
  ///
  ///
  Future<bool> update(Project project) async {
    try {
      final db = await _db.Database().openConnection();

      await storeRef.update(db, project.toJson(),
          finder: Finder(filter: Filter.equals("id", project.id)));
      return true;
    } catch (e) {
      rethrow;
    }
  }

  /// #### Delete
  /// - This method is responsible for delete a project.
  ///
  /// ##### Parameters:
  /// * `String id`: Project id.
  ///
  /// #### exemple:
  ///
  /// ```dart
  ///    await ProjectRepository.instance.delete(id);
  /// ```
  ///
  Future<Response> delete(String id) async {
    try {
      final db = await _db.Database().openConnection();

      await storeRef.delete(db,
          finder: Finder(filter: Filter.equals('id', id)));
      return Response.ok(jsonEncode(id));
    } catch (e) {
      rethrow;
    }
  }

  /// #### FindById
  ///
  /// - This method is responsible for find a project by id.
  ///
  /// ##### Parameters:
  /// * `String id`: Project id.
  ///
  /// #### exemple:
  ///
  /// ```dart
  ///  final project = await ProjectRepository.instance.findById(id);
  /// ```
  Future<Response> findById(String id) async {
    try {
      final db = await _db.Database().openConnection();

      final Finder finder = Finder(filter: Filter.equals('id', id));
      final project = await storeRef.findFirst(db, finder: finder);
      if (project == null) {
        return Response.notFound(jsonEncode(id));
      }
      return Response.ok(jsonEncode(project));
    } catch (e) {
      rethrow;
    }
  }

  /// #### findByUserId
  ///
  /// - This method is responsible for find a project by user id.
  ///
  /// ##### Parameters:
  /// * `String ownerId`: User id.
  ///
  /// #### exemple:
  ///
  /// ```dart
  /// final project = await ProjectRepository.instance.findByUserId(ownerId);
  /// ```
  ///
  Future<List<Project>> findByUser(String ownerId) async {
    try {
      final db = await _db.Database().openConnection();

      final projects = await storeRef.find(db,
          finder: Finder(filter: Filter.equals('ownerId', ownerId)));

      return projects.map((project) => Project.fromJson(project)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// #### findByStatus
  ///
  /// - This method is responsible for find a project by status.
  /// #### exemple:
  ///
  /// ```dart
  /// final projects = await ProjectRepository.instance.findAll();
  /// ```
  Future<List<Project>?> findAll() async {
    try {
      final db = await _db.Database().openConnection();

      final projects = await storeRef.find(db,
          finder: Finder(sortOrders: [SortOrder('name')]));

      if (projects.isEmpty) {
        return null;
      }

      final list = projects.map((e) => Project.fromJson(e)).toList();
      return list;
    } catch (e) {
      rethrow;
    }
  }
}
