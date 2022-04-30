import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../core/database/database.dart';
import '../core/shared/utils.dart';
import '../models/user_model.dart';

class UserRepository {
  static final UserRepository instance = UserRepository._internal();
  static const String collectionName = 'user';
  factory UserRepository() {
    return instance;
  }

  UserRepository._internal();

  Future<User?>? findByEmail(String email) async {
    final db = await Database().openConnection();
    final collection = db.collection(collectionName);
    final user = await collection.findOne(where.eq('email', email));
    if (user != null) {
      return User.fromJson(user);
    }
    return null;
  }

  //find by id
  Future<User?>? findById(String id) async {
    final db = await Database().openConnection();
    final collection = db.collection(collectionName);
    final user = await collection.findOne(where.eq('id', id));
    if (user != null) {
      await db.close();
      return User.fromJson(user);
    }
    await db.close();
    return null;
  }

  // get all users
  Future<List<User>> findAll() async {
    final db = await Database().openConnection();

    final users = await db.collection(collectionName).find().toList();
    await db.close();
    return users.map((user) => User.fromJson(user)).toList();
  }

  Future<void> add(String username, String password, String email) async {
    try {
      final db = await Database().openConnection();

      final userAlreadyRegistrated =
          await db.collection(collectionName).findOne(where.eq("email", email));

      if (userAlreadyRegistrated != null) {
        await db.close();
        throw Exception("User already registered");
      }

      final passwordToSave = await Utils.hashPassword(password);

      final user = User(
        id: Uuid().v4(),
        name: username,
        email: email,
        password: passwordToSave,
      );

      await db.collection(collectionName).insert(user.toJson());
      await db.close();
    } catch (error) {
      rethrow;
    }
  }

  deleteAll() async {
    final db = await Database().openConnection();
    return await db.collection(collectionName).drop();
  }

  delete(String id) async {
    try {
      final db = await Database().openConnection();
      await db.collection(collectionName).remove(where.eq('id', id));
      await db.close();
    } catch (error) {
      rethrow;
    }
  }
}
