import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class HomeController {
  Handler get handler {
    final router = Router();
    
    router.get('/', (Request request) {
      String message = JsonEncoder.withIndent('  ').convert({
        'message': 'Hello, World!',
        'datetime': DateTime.now().toString(),
      });
      return Response.ok(message);
    });

    // Mount Controller
    //router.mount('/', HomeController().handler);

    router.all('/<ignoed|.*>', (Request request) {
      return Response.notFound('Route Not Found');
    });

    return router;
  }
}
