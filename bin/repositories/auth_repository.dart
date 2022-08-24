import 'dart:convert';
import 'dart:io';
import 'package:sembast/sembast.dart';
import 'package:shelf/shelf.dart';
import '../core/database/database.dart' as _db;
import '../core/shared/utils.dart';
import '../models/session_model.dart';
import '../models/user_model.dart';
import 'user_repository.dart';

class AuthRepository {
  /// Authentication repository singleton

  //singleton
  AuthRepository._();
  static final AuthRepository instance = AuthRepository._();
  factory AuthRepository() => instance;

  //database
  static const String _collectionName = 'auth';

  StoreRef storeRef = StoreRef(_collectionName);

  /// ### Login
  ///
  /// ##### Description
  ///   - This method is responsible for login a user.
  ///
  /// ##### Parameters:
  ///   * `String email`: User email.
  ///   * `String password`: User password.
  ///
  /// #### exemple:
  ///
  /// ```dart
  ///   await AuthRepository.instance.login('user@email.com', '123456');
  /// ```
  ///
  /// .
  Future<Response> login(String email, String password) async {
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
  }

  /// #### verifyToken
  ///
  /// ##### Description
  ///  - This method is responsible for verify and validate a session token.
  ///
  /// ##### Parameters:
  ///  * `String token`: Session token.
  ///
  /// #### exemple:
  /// ```dart
  ///   await AuthRepository.instance.verifyToken('token');
  /// ```
  Future<bool> verifyToken(String token) async {
    final db = await _db.Database().openConnection();
    final Finder finder = Finder(filter: Filter.equals("sessionToken", token));
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
  }

  /// #### logout
  ///
  /// ##### Description
  /// - This method is responsible for logout a user.
  ///
  ///  it uses the session token to find the session and remove it.
  ///
  /// ##### Parameters:
  /// * `String token`: Session token.
  ///
  /// #### exemple:
  /// ```dart
  ///  await AuthRepository.instance.logout('token');
  /// ```

  Future<Response> logout(String token) async {
    final db = await _db.Database().openConnection();
    final Finder finder = Finder(filter: Filter.equals("sessionToken", token));
    final session = await storeRef.findFirst(db, finder: finder);
    if (session == null) {
      return Response.ok(jsonEncode('session not found'));
    }
    await storeRef.delete(db, finder: finder);
    return Response.ok(jsonEncode('session deleted'));
  }

  /// #### getSession
  ///
  /// ##### Description
  /// - This method is responsible for get a session by token.
  ///
  /// ##### Parameters:
  ///   * `String token`: Session token.
  ///
  /// #### exemple:
  /// ```dart
  ///  await AuthRepository.instance.getSession('token');
  /// ```
  ///
  ///
  Future<User?> getUserByToken(String? token) async {
    final db = await _db.Database().openConnection();

    final Finder finder = Finder(filter: Filter.equals("sessionToken", token));
    final session = await storeRef.findFirst(db, finder: finder);

    if (session == null) {
      return null;
    }
    Session _session = Session.fromJson(session.value);
    final user = await UserRepository.instance.findByEmail(_session.username);
    return user;
  }
}
