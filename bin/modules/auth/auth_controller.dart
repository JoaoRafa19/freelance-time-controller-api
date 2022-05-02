import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../repositories/auth_repository.dart';
import '../../repositories/user_repository.dart';

part 'auth_controller.g.dart';

class AuthController {
  @Route.post('/create')
  Future<Response> create(Request request) async {
    try {
      final repository = UserRepository.instance;
      Map body = jsonDecode(await request.readAsString());
      if (body.containsKey('name') &&
          body.containsKey('password') &&
          body.containsKey('email')) {
        final userAlreadyRegistrated =
            await repository.findByEmail(body['email']);
        if (userAlreadyRegistrated != null) {
          throw Exception("User already registered");
        }
        final validateEmail = body['email'];
        if (!validateEmail.contains('@')) {
          throw Exception("Invalid email");
        }
        await repository.add(body['name'], body['password'], validateEmail);
        return Response.ok(json.encode('user created'));
      }
      return Response.badRequest(body: 'name and password are required');
    } catch (e) {
      return Response.badRequest(body: e.toString());
    }
  }

  //delete all users
  @Route.delete('/deleteall')
  Future<Response> deleteAll(Request request) async {
    try {
      final repository = UserRepository.instance;
      await repository.deleteAll();
      return Response.ok(json.encode('all users deleted'));
    } catch (e) {
      return Response.internalServerError(body: e.toString());
    }
  }

  @Route.delete('/delete')
  Future<Response> del(Request req) async {
    try {
      final repository = UserRepository.instance;
      Map<String, dynamic> params = req.url.queryParameters;
      if (params.containsKey('id')) {
        final user = await repository.findById(params['id']);
        if (user == null || user.id == null) {
          throw Exception("User not found");
        }
        await repository.delete(user.id!);
        return Response.ok(json.encode('user deleted'));
      } else if (params.containsKey('email')) {
        final user = await repository.findByEmail(params['email']);
        if (user == null || user.id == null) {
          throw Exception("User not found");
        }
        await repository.delete(user.id!);
        return Response.ok(json.encode('user deleted'));
      }
      return Response.badRequest(body: 'id or email are required');
    } catch (e) {
      return Response.internalServerError(body: e.toString());
    }
  }

  @Route.get('/login')
  Future<Response> login(Request req) async {
    try {
      final repository = AuthRepository.instance;
      Map<String, dynamic> params = req.url.queryParameters;

      if (params.containsKey('email') && params.containsKey('password')) {
        Response result =
            await repository.login(params["email"], params["password"]);
        return result;
      }
      final response = Response(HttpStatus.unauthorized,
          body: "incorrect user and/or password");
      return response;
    } catch (error) {
      return Response.internalServerError(
          body: jsonEncode(
              {"message": 'a problem ocourred', "error": error.toString()}));
    }
  }

  Router get router => _$AuthControllerRouter(this);
}
