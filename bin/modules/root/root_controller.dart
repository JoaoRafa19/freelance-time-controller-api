import 'dart:developer';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../core/database/database.dart';

part 'root_controller.g.dart';

class RootController {
  @Route.get('/')
  Future<Response> users(Request req) async {
    try {
      final db = await Database().openConnection();
      return Response.ok("ola mundo");
    } catch (e) {
      log(e.toString());
      return Response.internalServerError(body: e.toString());
    }
  }

  Router get router => _$RootControllerRouter(this);
}
