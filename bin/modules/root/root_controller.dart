import 'dart:developer';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../../core/shared/coreconfig.dart';
import '../../core/shared/utils.dart' show makeResponse;

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
      return makeResponse(200, body: responseBody);
    } catch (e) {
      log(e.toString());
      return makeResponse(HttpStatus.internalServerError,
          stringbody: e.toString());
    }
  }

  Router get router => _$RootControllerRouter(this);
}
