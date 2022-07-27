import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shelf/shelf.dart';

Future<String> hashPassword(String password) async {
  var bytes = utf8.encode(password);
  var digest = sha1.convert(bytes);

  return digest.toString();
}

Response makeResponse(int statusCode, {String? stringbody, Map? body}) {
  if (stringbody != null) {
    return Response(statusCode, body: stringbody);
  }
  if (body != null) {
    return Response(statusCode, body: jsonEncode(body));
  }
  return Response(statusCode);
}

Response makeErrorResponse(
  Exception e, {
  int? statusCode,
}) {
  return makeResponse(statusCode ?? 500, body: {
    'traceback error': e.toString(),
  });
}
