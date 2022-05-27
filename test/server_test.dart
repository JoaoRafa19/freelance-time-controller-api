
import 'package:http/http.dart';
import 'package:shelf_test_handler/shelf_test_handler.dart';
import 'package:test/test.dart';

void main() {
  late ShelfTestServer server;
  setUp(() async {
    server = await ShelfTestServer.create();
  });
  test("client performs protocol handshake", () async {
    final uri = Uri.parse('http://localhost:8000/');
    final resp = await get(uri);

    expect(resp.body, 'Hello World!');
    
    // Requests made against `server.url` will be handled by the handlers we
    // declare.

    // If the client makes any unexpected requests, the test will fail.
  });

  tearDown(() {
    server.close(force: true);
  });
}
