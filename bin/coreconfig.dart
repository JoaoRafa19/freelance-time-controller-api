//singleton config
import 'package:dotenv/dotenv.dart';

class Config {
  static final Config instance = Config._internal();
  factory Config() {
    return instance;
  }
  Config._internal();

  static DotEnv dotenv = DotEnv(includePlatformEnvironment: true);
  String? get port => dotenv.map['PORT'];
  String? get mongoUrl => dotenv.map['MONGO_URL'];
  static void initialize() {
    dotenv.load(['.env']);
    if (dotenv.isEveryDefined(['PORT', 'MONGO_URL'])) {
      print('Config loaded');
    } else {
      throw Exception("Config not loaded");
    }
  }
}
