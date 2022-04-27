import 'package:shelf_router/shelf_router.dart';

import 'controllers/home_controller.dart';

class RouteHandler {
  RouteHandler(Router app) {
    app.mount('/', HomeController().handler);
  }
}
