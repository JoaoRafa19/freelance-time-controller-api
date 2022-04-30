import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../core/database/database.dart';
import '../core/shared/utils.dart';
import '../models/user_model.dart';
import 'user_repository.dart';

class AuthRepository {
  //singleton
  static final AuthRepository instance = AuthRepository._internal();
  factory AuthRepository() => instance;
  AuthRepository._internal();

  //database
  static const String collectionName = 'user';
  static const String collectionNameToken = 'token';
  static const String collectionSessionName = 'sessions';

  DbCollection collection = DbCollection(Database().db, collectionName);
  DbCollection sessions = DbCollection(Database().db, collectionSessionName);
  String secret = 'secret';

  Future<Response> login(String username, String password) async {
    try {
      final UserRepository userRepository = UserRepository.instance;
      User? user = await userRepository.findByEmail(username);

      if (user == null) {
        throw Exception("User not found");
      }
      if (await Utils.hashPassword(password) == user.password) {
        print("password match");
      }
      return Response.forbidden('user no found');
    } catch (e) {
      rethrow;
    }
  }
}
