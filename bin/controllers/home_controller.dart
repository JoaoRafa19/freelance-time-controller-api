import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class HomeController {
  Handler get handler {
    final router = Router();

    router.get('/', (Request request) {
      String message = JsonEncoder.withIndent('  ').convert({
        'message': 'Api em desenolvimento',
        'server datetime': DateTime.now().toString(),
      });
      return Response.ok(message,
          headers: {'content-type': 'application/json'});
    });

    router.get('/testhome', (Request request) {
      return Response.ok("teste realizado com sucesso");
    });

    // Mount Controller
    //router.mount('/', HomeController().handler);

    router.all('/<ignoed|.*>', (Request request) {
      return Response.notFound('Route Not Found');
    });

    return router;
  }
}
