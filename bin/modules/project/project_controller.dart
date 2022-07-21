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
      final User? user = await AuthRepository.instance.getUserByToken(token);
      if (user == null) {
        return makeResponse(HttpStatus.unauthorized,
            body: {'error': 'Unauthorized'});
      }
      final repository = ProjectRepository.instance;
      final projects = await repository.findAll();
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

      final User? user = await AuthRepository.instance.getUserByToken(token!);
      if (user == null) {
        return makeResponse(HttpStatus.unauthorized,
            body: {'error': 'Unauthorized'});
      }
      final projects = await ProjectRepository.instance.findByUser(user.id!);
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

      final User? user = await AuthRepository.instance.getUserByToken(token!);
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
      final _repository = ProjectRepository.instance;
      final _autRepo = AuthRepository.instance;
      final Map body = jsonDecode(await req.readAsString());

      if (!(body.isNotEmpty &&
          body.containsKey('name') &&
          body.containsKey('description'))) {
        return makeResponse(HttpStatus.badRequest,
            body: {'error': 'Bad Request'});
      }
      final token = req.headers[Strings.acesstoken.value];

      final user = await _autRepo.getUserByToken(token!);
      if (user == null) {
        return makeResponse(HttpStatus.unauthorized,
            body: {'error': 'unauthorized'});
      }

      final project = Project.newProject(
          user.id!, body['name'], body['description'], Uuid().v4());
      return await _repository.create(project);
    } catch (e) {
      return makeResponse(HttpStatus.badRequest,
          body: {'error': 'Bad Request'});
    }
  }

  @Route.put('/<projectId>/newtask')
  Future<Response> createTask(Request req, String projectId) async {
    try {
      final _repository = ProjectRepository.instance;
      final _authRepo = AuthRepository.instance;

      final body = jsonDecode(await req.readAsString());

      if (!(body.isNotEmpty &&
          body.containsKey('name') &&
          body.containsKey('description') &&
          body.containsKey('estimate') &&
          body.containsKey('priority'))) {
        throw Exception('required params not found');
      }

      final token = req.headers[Strings.acesstoken.value];
      final user = await _authRepo.getUserByToken(token!);

      if (user == null) {
        return makeResponse(HttpStatus.unauthorized,
            body: {'error': 'unauthorized'});
      }

      final allProjects = await _repository.findAll();

      if (allProjects == null) {
        throw Exception('no projects found');
      }

      final userpProjects =
          allProjects.where((project) => project!.ownerId == user.id).toList();
      if (userpProjects.isEmpty) {
        throw Exception('no projects found');
      }
      final project =
          userpProjects.firstWhereOrNull((project) => project!.id == projectId);

      if (project == null) {
        throw Exception('project no found or you dont have access');
      }

      final task = Task.newTask(body);
      project.tasks.add(task);

      return await _repository.update(project);
    } on DatabaseException {
      return makeResponse(HttpStatus.internalServerError,
          body: {'error': 'DatabaseError'});
    } on Exception catch (e) {
      return makeErrorResponse(e);
    }
  }

  Router get router => _$ProjectControllerRouter(this);
}
