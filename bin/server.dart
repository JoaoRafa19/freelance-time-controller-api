import 'dart:io';

import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import 'routehandler.dart';

main(List<String> args) async {
  final app = Router();
  final address = InternetAddress.anyIPv4.address;
  RouteHandler(app);

  // Start the server.
  final port = int.parse(Platform.environment['PORT'] ?? '8000');
  var server = await io.serve(app, address, port);
  server.handleError((error) {
    print('Error: $error');
  });
  server.serverHeader = 'dart-server';
  server.autoCompress = true;

  print('Serving at http://${server.address.address}:${server.port}');
}

Future initialConfiguration() async {}
