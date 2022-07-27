import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../core/shared/utils.dart';
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
        final validateEmail = body['email'];
        if (!validateEmail.contains('@')) {
          throw Exception("Invalid email");
        }
        await repository.add(body['name'], body['password'], validateEmail);
        return Response.ok(json.encode('user created'));
      }
      return Response.badRequest(
          body: jsonEncode({'error': 'name and password are required'}));
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({'error': e.toString()}));
    }
  }

  

  @Route.get('/login')
  Future<Response> login(Request req) async {
    try {
      final repository = AuthRepository.instance;
      Map<String, dynamic> params = req.url.queryParameters;

      if (params.containsKey('email') && params.containsKey('password')) {
        if ((params['email'] as String ).isEmpty|| (params['password'] as String).isEmpty) {
          return makeErrorResponse(
            Exception('email and password are required'),
            statusCode: HttpStatus.badRequest,
          );
        }
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

  @Route.get('/logout')
  Future<Response> logout(Request req) async {
    try {
      final repository = AuthRepository.instance;
      Map<String, dynamic> params = req.url.queryParameters;
      final token = params["token"];
      if (token == null) {
        return Response.badRequest(
            body: jsonEncode({"error": "token is required"}));
      }
      if (params.containsKey('token')) {
        Response result = await repository.logout(params["token"]);
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
