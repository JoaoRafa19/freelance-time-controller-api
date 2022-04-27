import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

main(List<String> args) async {
  final app = Router();
  final address = InternetAddress.anyIPv4.address;
  
  final handler = const Pipeline().addMiddleware(logRequests()).addHandler(app);

  // Start the server.
  final port = int.parse(Platform.environment['PORT'] ?? '8000');
  var server = await io.serve(handler, address, port);
  server.handleError((error) {
    print('Error: $error');
  });
  server.serverHeader = 'dart-server';
  server.autoCompress = true;
  server.serverHeader = 'dart-server';

  print('Serving at http://${server.address.address}:${server.port}');
}

Future initialConfiguration() async {}
