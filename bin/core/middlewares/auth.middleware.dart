import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/src/request.dart' as req;

import '../../repositories/auth_repository.dart';

/// Authentication middleware
authMiddleware() {
  return createMiddleware(requestHandler: (req.Request request) async {
    try {
      final token = request.headers['x-access-token'];
      if (token == null) {
        return Response.forbidden(jsonEncode({'error': 'unauthorized'}));
      }
      final repository = AuthRepository.instance;
      final session = await repository.verifyToken(token);

      if (!session) {
        return Response.forbidden(jsonEncode({'error': 'unauthorized'}));
      }
      return null;
    } catch (error) {
      if (error is FormatException) {
        return Response.badRequest(body: jsonEncode({'error': 'invalid json'}));
      }

      return Response.internalServerError(
          body: jsonEncode({'error': error.toString()}));
    }
  }, responseHandler: (Response response) {
    return response.change(headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'POST, GET, OPTIONS, PUT, DELETE',
      'Access-Control-Allow-Headers': 'Origin, Content-Type',
      'Content-Type': 'application/json'
    });
  });
}
