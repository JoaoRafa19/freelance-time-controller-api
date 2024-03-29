import 'dart:convert';
import 'dart:io';
import 'package:sembast/sembast.dart';
import 'package:shelf/shelf.dart';
import 'package:collection/collection.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:uuid/uuid.dart';
import '../../core/shared/constants.dart';
import '../../core/shared/utils.dart';
import '../../models/project_model.dart';
import '../../models/task_model.dart';
import '../../models/user_model.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/project_repository.dart';

part 'project_controller.g.dart';

class ProjectController {
  static final _authRepository = AuthRepository.instance;
  static final _projectRepository = ProjectRepository.instance;

  @Route.get('/all')
  Future<Response> projects(Request req) async {
    try {
      final token = req.headers[Strings.acesstoken.value];
      if (token == null) {
        return makeErrorResponse(
          Exception('token is required'),
          statusCode: HttpStatus.unauthorized,
        );
      }
      print(token);
      final User? user = await _authRepository.getUserByToken(token);
      if (user == null) {
        return makeResponse(HttpStatus.unauthorized,
            body: {'error': 'Unauthorized'});
      }

      final projects = await _projectRepository.findAll();
      return Response.ok(jsonEncode(projects));
    } catch (e) {
      return makeResponse(HttpStatus.badRequest,
          body: {'error': 'Bad Request'});
    }
  }

  @Route.get('/')
  Future<Response> getProjects(Request req) async {
    try {
      final token = req.headers[Strings.acesstoken.value];

      final User? user = await _authRepository.getUserByToken(token!);
      if (user == null) {
        return makeResponse(HttpStatus.unauthorized,
            body: {'error': 'Unauthorized'});
      }
      final projects = await _projectRepository.findByUser(user.id!);
      return Response.ok(jsonEncode(projects));
    } catch (e) {
      return makeResponse(HttpStatus.badRequest,
          body: {'error': 'Bad Request'});
    }
  }

  @Route.put('/<id>')
  Future<Response> updateProject(Request resquest, String id) async {
    try {
      final token = resquest.headers[Strings.acesstoken.value];

      final User? user = await _authRepository.getUserByToken(token!);
      if (user == null) {
        return makeResponse(HttpStatus.unauthorized,
            body: {'error': 'Unauthorized'});
      }

      return Response.ok(jsonEncode('project updated'));
    } on DatabaseException {
      return makeResponse(HttpStatus.internalServerError,
          body: {'error': 'Internal Server Error'});
    } on Exception catch (e) {
      return makeErrorResponse(e, statusCode: HttpStatus.internalServerError);
    }
  }

  @Route.post('/')
  Future<Response> createProjects(Request req) async {
    try {
      final Map body = jsonDecode(await req.readAsString());

      if (!(body.isNotEmpty &&
          body.containsKey('name') &&
          body.containsKey('description'))) {
        return makeResponse(HttpStatus.badRequest,
            body: {'error': 'Bad Request'});
      }
      final token = req.headers[Strings.acesstoken.value];

      final user = await _authRepository.getUserByToken(token!);
      if (user == null) {
        return makeResponse(HttpStatus.unauthorized,
            body: {'error': 'unauthorized'});
      }

      final project = Project.newProject(
          user.id!, body['name'], body['description'], Uuid().v4());
      return await _projectRepository.create(project);
    } catch (e) {
      return makeResponse(HttpStatus.badRequest,
          body: {'error': 'Bad Request'});
    }
  }

  @Route.put('/<projectId>/newtask')
  Future<Response> createTask(Request req, String projectId) async {
    try {
      final body = jsonDecode(await req.readAsString());

      if (!(body.isNotEmpty &&
          body.containsKey('name') &&
          body.containsKey('description') &&
          body.containsKey('estimate') &&
          body.containsKey('priority'))) {
        throw Exception('required params not found');
      }

      final token = req.headers[Strings.acesstoken.value];
      final user = await _authRepository.getUserByToken(token);

      if (user == null) {
        return makeResponse(HttpStatus.unauthorized,
            body: {'error': 'unauthorized'});
      }
      final projects = await _projectRepository.findByUser(user.id!);
      final project =
          projects.firstWhereOrNull((project) => project.id == projectId);
      if (project == null) {
        throw Exception('project no found or you dont have access');
      }

      final task = Task.newTask(body);
      project.tasks.add(task);

      final result = await _projectRepository.update(project);

      if (result) {
        return makeResponse(HttpStatus.ok, body: task.toJson());
      } else {
        throw Exception("Could not create this project");
      }
    } on DatabaseException {
      return makeResponse(HttpStatus.internalServerError,
          body: {'error': 'DatabaseError'});
    } on Exception catch (e) {
      return makeErrorResponse(e);
    } catch (e) {
      return makeErrorResponse(e as Exception);
    }
  }

  @Route.get('/<projectId>/task/<taskId>')
  Future<Response> getTask(Request req, String projectId, String taskId) async {
    try {
      final project = await _projectRepository.findById(projectId);
      if (project == null) {
        throw Exception("project not found");
      }
      final task =
          project.tasks.firstWhereOrNull((element) => element.id == taskId);
      if (task == null) {
        throw Exception("project not found");
      }

      return makeResponse(HttpStatus.found, body: task.toJson());
    } catch (e) {
      return makeErrorResponse(e as Exception);
    }
  }

  @Route.put('/<projectId>/task/<taskId>')
  Future<Response> updateTask(
      Request req, String projectId, String taskId) async {
    try {
      Map<String, dynamic> body = jsonDecode(await req.readAsString());
      final project = await _projectRepository.findById(projectId);
      if (project == null) {
        throw Exception("project not found");
      }
      final task =
          project.tasks.firstWhereOrNull((element) => element.id == taskId);
      if (task == null) {
        throw Exception("Task not found");
      }
      var newTask = task.toJson();
      for (var k in body.keys) {
        newTask[k] = body[k];
      }
      project.tasks[project.tasks.indexOf(task)] = Task.fromJson(newTask)
        ..updateAt = DateTime.now();
      final result = await _projectRepository.update(project);
      if (!result) {
        throw Exception("Cant update task");
      }
      return makeResponse(HttpStatus.ok, body: Task.fromJson(newTask).toJson());
    } catch (e) {
      return makeErrorResponse(e as Exception);
    }
  }

  @Route.delete('/<projectId>/task/<taskId>')
  Future<Response> deleteTask(
      Request req, String projectId, String taskId) async {
    try {
      final project = await _projectRepository.findById(projectId);
      if (project == null) {
        throw Exception("project not found");
      }
      final task =
          project.tasks.firstWhereOrNull((element) => element.id == taskId);
      if (task == null) {
        throw Exception("project not found");
      }
      project.tasks.remove(task);
      await _projectRepository.update(project);
      return makeResponse(HttpStatus.ok, body: project.toJson());
    } catch (e) {
      return makeErrorResponse(e as Exception);
    }
  }

  Router get router => _$ProjectControllerRouter(this);
}
