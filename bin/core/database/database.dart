import 'package:mongo_dart/mongo_dart.dart';
import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:dart_dotenv/dart_dotenv.dart';

import '../../coreconfig.dart';

class Database {
  late Db db;
  Future<Db> openConnection() async {
    db = Db(Config.instance.mongoUrl!);
    await db.open();
    return db;
  }

// Future initialize() async {
//     _db = Db('mongodb://localhost:27017');
//     await _db.open();
//     _collection = _db.collection('user');
//   }

}
