import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'project_controller.g.dart';


class ProjectController{
  @Route.get('/')
  Future<Response> projects(Request req)async{
    return Response.ok('ola');

  }
  Router get router => _$ProjectControllerRouter(this);
}