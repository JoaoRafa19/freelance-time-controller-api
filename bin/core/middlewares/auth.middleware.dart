import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// Authentication middleware
authMiddleware() {
  
  return createMiddleware(requestHandler: (Request request) {
    if (request.headers['token'] == null) {
      return Response.forbidden('Unauthorized');
    }
  }, responseHandler: (Response response) {
    return response.change(headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'POST, GET, OPTIONS, PUT, DELETE',
      'Access-Control-Allow-Headers': 'Origin, Content-Type',
    });
  });
}
