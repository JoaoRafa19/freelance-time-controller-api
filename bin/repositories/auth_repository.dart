import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:sembast/sembast.dart';
import 'package:shelf/shelf.dart';
import '../core/database/database.dart' as _db;
import '../core/shared/utils.dart';
import '../models/session_model.dart';
import 'user_repository.dart';

class AuthRepository {
  /// Authentication repository singleton

  //singleton
  static final AuthRepository instance = AuthRepository._internal();
  factory AuthRepository() => instance;
  AuthRepository._internal();

  //database
  static const String collectionName = 'auth';

  StoreRef storeRef = StoreRef(collectionName);

  Future<Response> login(String email, String password) async {
    try {
      final UserRepository userRepository = UserRepository.instance;
      final db = await _db.Database().openConnection();
      final user = await userRepository.findByEmail(email);
      if (user == null) {
        throw Exception("User not found");
      }
      if (await hashPassword(password) == user.password) {
        final session = Session.newSession(user.email!);
        await storeRef.add(db, session.toJson());

        return Response.ok(jsonEncode(session));
      } else {
        final response = Response(HttpStatus.unauthorized,
            body: 'forbiden incorrect user and/or password');

        return response;
      }
    } catch (e) {
      rethrow;
    }
  }
  /// Verify if the sessionToken is valid
  /// return false if the sessionToken expire date is greater than now
  /// 
  /// ex: sessionToken.expireDate > DateTime.now()
  /// [sessionToken] is the sessionToken to verify
  Future<bool> verifyToken(String token) async {
    try {
      final db = await _db.Database().openConnection();
      final Finder finder =
          Finder(filter: Filter.equals("sessionToken", token));
      final session = await storeRef.findFirst(db, finder: finder);
      if (session == null) {
        return false;
      }
      print(session.value);

      final _session = Session.fromJson(session.value);

      if (_session.expiresAt.isBefore(DateTime.now())) {
        return false;
      }

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<Response> logout(String token) async {
    try {
      final db = await _db.Database().openConnection();
      final Finder finder =
          Finder(filter: Filter.equals("sessionToken", token));
      final session = await storeRef.findFirst(db, finder: finder);
      if (session == null) {
        return Response.ok(jsonEncode('session not found'));
      }
      await storeRef.delete(db, finder: finder);
      return Response.ok(jsonEncode('session deleted'));
    } catch (error) {
      return Response.internalServerError(
          body: jsonEncode(
              {"message": 'a problem ocourred', "error": error.toString()}));
    }
  }
}
