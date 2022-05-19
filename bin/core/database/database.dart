import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast.dart' as sb;
import '../shared/coreconfig.dart';

class Database {
  final sb.DatabaseFactory _dbFactory = databaseFactoryIo;

  Future<sb.Database> openConnection() async {
    sb.Database db = await _dbFactory.openDatabase(Config.instance.database!);
    return db;
  }
}
