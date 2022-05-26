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

  Future<User?> findByEmail(String email) async {
    final database = await _db.Database().openConnection();
    final finder = Finder(filter: Filter.equals('email', email));
    final recordSnapshot = await storeRef.findFirst(database, finder: finder);
    if (recordSnapshot != null) {
      return User.fromJson(recordSnapshot.value);
    }
    return null;
  }

  ///find a single user by [id]
  ///return null if the user is not found
  Future<User?>? findById(String id) async {
    
    final db = await _db.Database().openConnection();

    final finder = Finder(filter: Filter.equals("id", id));
    final user = await storeRef.findFirst(db, finder: finder);
    if (user != null) {
      return User.fromJson(user.value);
    }
    return null;
  }

  ///get all the users in database
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

  deleteAll() async {
    final db = await _db.Database().openConnection();
    return await storeRef.delete(db, finder: Finder());
  }

  delete(String id) async {
    try {
      final db = await _db.Database().openConnection();
      var finder = Finder(
          filter: Filter.equals('id', id), sortOrders: [SortOrder('id')]);
      await storeRef.delete(db, finder: finder);
    } catch (error) {
      rethrow;
    }
  }
}
