import 'dart:io';

import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import 'routehandler.dart';

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final app = Router();
  final address = InternetAddress.anyIPv4;
  RouteHandler(app);
  // For running in containers, we respect the PORT environment variable.
  final port = int.fromEnvironment('PORT', defaultValue: 8080);

  var server = await io.serve(app, address, port);

  server.autoCompress = true;
  print('server running on http://${server.address}:${server.port}');
  print("alteração atoa");
  print('Server listening on port ${server.port}');
}
