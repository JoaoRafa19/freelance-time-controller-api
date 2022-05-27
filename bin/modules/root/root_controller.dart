import 'dart:convert';
import 'dart:developer';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../core/shared/coreconfig.dart';

part 'root_controller.g.dart';

class RootController {
  @Route.get('/')
  Future<Response> users(Request req) async {
    try {
      Map<String, dynamic> responseBody = {
        'database': Config.instance.database,
        'address': Config.instance.address,
        'datetime': DateTime.now().toString(),
      };
      Response response = Response(200, body: jsonEncode(responseBody));
      return response;
    } catch (e) {
      log(e.toString());
      return Response.internalServerError(body: e.toString());
    }
  }

  Router get router => _$RootControllerRouter(this);
}
