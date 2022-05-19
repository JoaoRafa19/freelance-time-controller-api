//singleton config
// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:io';

import 'package:dotenv/dotenv.dart';

class Config {
  static final Config instance = Config._internal();
  factory Config() {
    return instance;
  }
  Config._internal();
  static final List<String> _defaultEnvParams = ['PORT', 'DATABASE'];

  static DotEnv dotenv = DotEnv(includePlatformEnvironment: true);
  String get portStr => dotenv.map['PORT'] ?? '3000';
  int get port => int.parse(portStr);
  String? get database => dotenv.map['DATABASE'];
  String get address => InternetAddress.anyIPv4.address;
  static void initialize(List<String> enviroment) {
    try {
      dotenv.load(enviroment);
      if (dotenv.isEveryDefined(_defaultEnvParams)) {
        print('Config loaded');
      } else {
        _defaultEnvParams.removeWhere((e) => dotenv.map[e] != null);
        throw Exception("Config not loaded, missing enviroment variables \n ${_defaultEnvParams.join(', ')}");
      }
    } catch (e) {
      print(e);
      exit(1);
    }
  }
}
