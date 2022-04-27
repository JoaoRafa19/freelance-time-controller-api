import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'auth_controller.g.dart';

class AuthController {
  @Route.get('/')
  Future<Response> findAll(Request request) async {
    return Response.ok('Hello World');
  }

  

  Router get router => _$AuthControllerRouter(this);
}
