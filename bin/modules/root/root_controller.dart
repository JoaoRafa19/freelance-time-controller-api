
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';


part 'root_controller.g.dart';

class RootController {
  @Route.get('/')
  Future<Response> users(Request req) async {
    return Response.ok("ola mundo");
  }

  Router get router => _$RootControllerRouter(this);
}
