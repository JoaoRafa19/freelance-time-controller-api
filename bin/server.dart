import 'dart:io';
import 'package:args/args.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'core/middlewares/auth.middleware.dart';
import 'core/shared/coreconfig.dart';
import 'modules/auth/auth_controller.dart';
import 'modules/root/root_controller.dart';
import 'modules/user/user_controller.dart';

main(List<String> args) async {
  // Arguments
  var parser = ArgParser()
    ..addOption('port',
        abbr: 'p', defaultsTo: '8080', help: "Port to listen on.")
    ..addFlag('logip', abbr: 'l', defaultsTo: false, help: "Log IP address.")
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
    ..mount('/index', RootController().router)
    ..mount(
        '/users',
        Pipeline()
            .addMiddleware(authMiddleware())
            .addHandler(UserController().router))
    ..mount('/auth', AuthController().router);
  // initialize server

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(createMiddleware(requestHandler: (request) {
        if (request.method == 'OPTIONS') {
          return Response.ok('', headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'POST, GET, OPTIONS, PUT, DELETE',
            'Access-Control-Allow-Headers': 'Origin, Content-Type',
          });
        }
        return null;
      }, responseHandler: (Response response) {
        return response.change(headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'POST, GET, OPTIONS, PUT, DELETE',
          'Access-Control-Allow-Headers': 'Origin, Content-Type',
        });
      }))
      .addHandler(router);
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

  if (arguments['logip']) {
    print('Databse ${Config.instance.database}');

    print('Logging IP address');

    _logIp();
  }
}

_logIp() {
  print("ipv4");
  print(InternetAddress.anyIPv4.address);
  print(InternetAddress.anyIPv4.host);
  print(InternetAddress.anyIPv4.rawAddress);
  print("ipv6");

  print(InternetAddress.anyIPv6.address);
  print(InternetAddress.anyIPv6.host);
  print(InternetAddress.anyIPv6.rawAddress);
}
