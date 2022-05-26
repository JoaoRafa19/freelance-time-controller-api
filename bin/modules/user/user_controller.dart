import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../models/user_model.dart';
import '../../repositories/user_repository.dart';

part 'user_controller.g.dart';

class UserController {
  @Route.get('/<id>')
  Future<Response> user(Request req, String id) async {
    final repository = UserRepository.instance;
    final user = await repository.findById(id);
    if (user == null) {
      return Response.notFound('User not found');
    }
    return Response.ok(jsonEncode(user));
  }

  @Route.get('/')
  Future<Response> getUserQuery(Request req) async {
    final repository = UserRepository.instance;
    final byEmail = req.url.queryParameters['email'];
    final byId = req.url.queryParameters['id'];
    if (byEmail != null) {
      final user = await repository.findByEmail(byEmail);
      if (user == null) {
        return Response.notFound('User not found');
      }
      return Response.ok(jsonEncode(user));
    }
    if (byId != null) {
      final user = await repository.findById(byId);
      if (user == null) {
        return Response.notFound('User not found');
      }
      final Response resp = Response.ok(jsonEncode(user));
      resp.headers['priority'] = 'id';
      return resp;
    }
    final users = await repository.findAll();
    return Response.ok(jsonEncode(users));
  }

  @Route.delete('/<id>')
  Future<Response> deleteUser(Request req, String id) async {
    final repository = UserRepository.instance;
    final user = await repository.findById(id);
    if (user == null) {
      return Response.notFound('User not found');
    }
    await repository.delete(user.id!);
    return Response.ok('User deleted');
  }

  Router get router => _$UserControllerRouter(this);
}
