import 'dart:io';
import 'package:args/args.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'core/shared/coreconfig.dart';
import 'modules/auth/auth_controller.dart';
import 'modules/user/user_controller.dart';

main(List<String> args) async {
  // Arguments
  var parser = ArgParser()
    ..addOption('port',
        abbr: 'p', defaultsTo: '8080', help: "Port to listen on.")
    ..addOption('enviroment',
        abbr: 'e',
        defaultsTo: '.env',
        help: "Enviroment file to load.",
        valueHelp: "filename")
    ..addFlag('help', abbr: 'h', negatable: false);

  var arguments = parser.parse(args);

  if (arguments['help']) {
    print('Usage: server [options]');
    print(parser.usage);
    exit(0);
  }
  // Enviroment definition
  print("Loading enviroment ${arguments['enviroment']}");
  Config.initialize([arguments['enviroment']]);

  final router = Router()
    ..get('/', (request) => Response.ok('Hello World!'))
    ..mount('/users', UserController().router)
    ..mount('/auth', AuthController().router);
  // initialize server

  final handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(router);
  // Start the server.
  var server =
      await io.serve(handler, Config.instance.address, Config.instance.port)
        ..handleError((error) {
          print('Error: $error');
        })
        ..serverHeader = 'dart-server'
        ..autoCompress = true
        ..serverHeader = 'dart-server';

  print('Serving at http://${server.address.address}:${server.port}');
}
