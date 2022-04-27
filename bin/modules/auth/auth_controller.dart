import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../repositories/user_repository.dart';

part 'auth_controller.g.dart';

class AuthController {
  @Route.get('/')
  Future<Response> findAll(Request request) async {
    return Response.ok('Hello World');
  }

  @Route.post('create')
  Future<Response> create(Request request) async {
    try {
      final repository = UserRepository.instance;
      final body = await request.readAsString();
      final json = jsonDecode(body);
      final username = json['username'] as String;
      final password = json['password'] as String;

      await repository.add(username, password);

      return Response.ok('User created');

    } catch (e) {
      return Response.internalServerError(body: e.toString());
    }
  }

  Router get router => _$AuthControllerRouter(this);
}
