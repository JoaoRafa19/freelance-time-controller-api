import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';

import '../core/database/database.dart' as _db;
import '../core/shared/utils.dart';
import '../models/user_model.dart';

class UserRepository {
  static final UserRepository instance = UserRepository._internal();
  static const String collectionName = 'user';
  StoreRef storeRef = StoreRef(collectionName);
  factory UserRepository() {
    return instance;
  }

  UserRepository._internal();

//   Future<User?> findByEmail(String email) async {
//     final database = await db.Database().openConnection();
//     final collection = db.collection(collectionName);
//     final user = await collection.findOne(where.eq("email", email));
//     if (user != null) {
//       return User.fromJson(user);
//     }
//     return null;
//   }

  //find by id
  // Future<User?>? findById(String id) async {
  //   final db = await Database().openConnection();
  //   final collection = db.collection(collectionName);
  //   final user = await collection.findOne(where.eq('id', id));
  //   if (user != null) {
  //     return User.fromJson(user);
  //   }
  //   return null;
  // }

  //get all users
  Future<List<User>> findAll() async {
    final db = await _db.Database().openConnection();

    final users = await storeRef.find(db);

    return users.map((record) => User.fromJson(record.value)).toList();
  }

  Future<void> add(String username, String password, String email) async {
    try {
      final db = await _db.Database().openConnection();

      var finder = Finder(
          filter: Filter.equals('email', email), sortOrders: [SortOrder('id')]);
      var records = await storeRef.find(db, finder: finder);

      if (records.isNotEmpty) {
        throw Exception("User already registered");
      }

      final passwordToSave = await Utils.hashPassword(password);

      final user = User(
        id: Uuid().v4(),
        name: username,
        email: email,
        password: passwordToSave,
      );

      await storeRef.add(db, user.toJson());
    } catch (error) {
      rethrow;
    }
  }

  // deleteAll() async {
  //   final db = await Database().openConnection();
  //   return await db.collection(collectionName).drop();
  // }

  // delete(String id) async {
  //   try {
  //     final db = await Database().openConnection();
  //     await db.collection(collectionName).remove(where.eq('id', id));
  //   } catch (error) {
  //     rethrow;
  //   }
  // }
}
