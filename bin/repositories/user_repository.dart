import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../core/database/database.dart';
import '../models/user_model.dart';

class UserRepository {

  static final UserRepository instance = UserRepository._internal();

  factory UserRepository() {
    return instance;
  }

  UserRepository._internal();

  Future<void> add(String username, String password) async {
    try {
      final db = await Database().openConnection();

      final userAlreadyRegistrated =
          await db.collection("user").findOne(where.eq("email", username));

      if (userAlreadyRegistrated != null) {
        throw Exception("User already registered");
      }

      final passwordToSave = await hashPassword(password);

      final user = User(
        id: null,
        name: username,
        email: username,
        password: passwordToSave,
      );

      //await db.collection("user").insert(user.toJson());
    } catch (error) {
      rethrow;
    }
  }

  Future<String> hashPassword(String password) async {
    var bytes = utf8.encode(password);
    var digest = sha1.convert(bytes);

    return password;
  }
}
