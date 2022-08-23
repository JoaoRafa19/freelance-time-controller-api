import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'core/middlewares/auth.middleware.dart';
import 'core/shared/coreconfig.dart';
import 'modules/auth/auth_controller.dart';
import 'modules/project/project_controller.dart';
import 'modules/root/root_controller.dart';
import 'modules/user/user_controller.dart';

main(List<String> args) async {
  // Arguments

  final router = Router()
    ..get('/', (request) => Response.ok('Hello World!'))
    ..mount('/index', RootController().router)
    ..mount(
        '/users',
        Pipeline()
            .addMiddleware(authMiddleware())
            .addHandler(UserController().router))
    ..mount(
        '/project',
        Pipeline()
            .addMiddleware(authMiddleware())
            .addHandler(ProjectController().router))
    ..mount('/auth', AuthController().router);
  // initialize server

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(createMiddleware(requestHandler: (request) {
        if (request.method == 'OPTIONS') {
          return Response.ok('', headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'POST, GET, OPTIONS, PUT, DELETE',
            'Access-Control-Allow-Headers':
                'Origin, Content-Type, x-access-token',
            'Content-Type': 'application/json'
          });
        }
        return null;
      }, responseHandler: (Response response) {
        return response.change(headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'POST, GET, OPTIONS, PUT, DELETE',
          'Access-Control-Allow-Headers':
              'Origin, Content-Type, x-access-token',
          'Content-Type': 'application/json'
        });
      }))
      .addHandler(router);
  // Start the server.
  var server = await io.serve(handler, Config.instance.address, 80)
    ..handleError((error) {
      print('Error: $error');
    })
    ..serverHeader = 'dart-server'
    ..autoCompress = true
    ..serverHeader = 'dart-server';

  print('Serving at http://${server.address.address}:${server.port}');
}
