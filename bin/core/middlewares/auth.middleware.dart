import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/src/request.dart' as req;

import '../../repositories/auth_repository.dart';
import '../shared/constants.dart';
import '../shared/utils.dart';

/// Authentication middleware
authMiddleware() {
  return createMiddleware(requestHandler: (req.Request request) async {
    try {
      final token = request.headers[Strings.acesstoken.value];

      if (token == null) {
        return makeResponse(HttpStatus.forbidden,
            stringbody: 'forbiden, no token provided');
      }
      final repository = AuthRepository.instance;
      final validSession = await repository.verifyToken(token);

      if (!validSession) {
        return makeResponse(HttpStatus.unauthorized,
            body: {'error': 'unauthorized'});
      }
      return null;
    } catch (error) {
      if (error is FormatException) {
        return makeResponse(HttpStatus.badRequest,
            body: {'error': 'invalid body'});
      }

      return makeResponse(HttpStatus.internalServerError,
          body: {'error': error.toString()});
    }
  }, responseHandler: (Response response) {
    return response.change(headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'POST, GET, OPTIONS, PUT, DELETE',
      'Access-Control-Allow-Headers': 'Origin, Content-Type, x-access-token',
      'Content-Type': 'application/json'
    });
  });
}
