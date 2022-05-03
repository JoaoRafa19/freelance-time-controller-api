import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import '../shared/coreconfig.dart';

class Database {
  late Db db;
  Future<Db> openConnection() async {
    db = await Db.create(Config.instance.mongoUrl!);
    log("Database conected at ${db.uriList}");
    await db.open();

    return db;
  }

}
