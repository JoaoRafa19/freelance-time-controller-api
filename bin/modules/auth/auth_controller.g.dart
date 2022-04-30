// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$AuthControllerRouter(AuthController service) {
  final router = Router();
  router.add('POST', r'/create', service.create);
  router.add('DELETE', r'/deleteall', service.deleteAll);
  router.add('DELETE', r'/delete', service.del);
  router.add('POST', r'/login', service.login);
  return router;
}
