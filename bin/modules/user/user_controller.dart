import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../repositories/user_repository.dart';

part 'user_controller.g.dart';

class UserController {
  @Route.get('/')
  Future<Response> users(Request req) async {
    final repository = UserRepository.instance;
    final users = await repository.findAll();
    return Response.ok(jsonEncode(users));
  }

  Router get router => _$UserControllerRouter(this);
}
