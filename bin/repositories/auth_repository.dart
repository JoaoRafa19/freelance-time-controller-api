import 'package:mongo_dart/mongo_dart.dart';

import '../core/database/database.dart';
import 'user_repository.dart';

class AuthRepository {
  //singleton
  static final AuthRepository instance = AuthRepository._internal();
  factory AuthRepository() => instance;
  AuthRepository._internal();

  //database
  static const String collectionName = 'user';
  static const String collectionNameToken = 'token';

  DbCollection collection = DbCollection(Database().db,  collectionName);
  String secret = 'secret';


  Future<String> login(String username, String password) async {
    try {
      final UserRepository userRepository = UserRepository.instance;
      final user = userRepository.findByEmail(username);

      if (user == null) {
        throw Exception("User not found");
      }

      return '';
    } catch (e) {
      rethrow;
    }
  }
}
