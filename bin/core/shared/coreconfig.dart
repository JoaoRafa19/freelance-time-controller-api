//singleton config
// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:io';

import 'package:dotenv/dotenv.dart';

import 'constants.dart';

class Config {
  static final Config instance = Config._internal();
  factory Config() {
    return instance;
  }
  Config._internal();
  static final List<String> _defaultEnvParams = [
    Strings.port.value,
    Strings.database.value
  ];

  static get expiresIn {
    if (env == Enviroment.dev) {
      return Duration(hours: 8);
    }
    return Duration(days: 7);
  }

  static Enviroment env = Enviroment.dev;

  static DotEnv dotenv = DotEnv(includePlatformEnvironment: true);
  String get portStr => '8080';
  int get port => int.parse(portStr);
  String? get database => 'database.db';
  String get address => InternetAddress.anyIPv4.address;
  static void initialize(List<String> enviroment) async {
    try {
      
        env = Enviroment.prod;
      
      if (dotenv.isEveryDefined(_defaultEnvParams)) {
        print('Config loaded');
      } else {
        _defaultEnvParams.removeWhere((e) => dotenv.map[e] != null);
        throw Exception(
            "Config not loaded, missing enviroment variables \n ${_defaultEnvParams.join(', ')}");
      }
    } catch (e) {
      print(e);
    }
  }
}

enum Enviroment {
  dev,
  prod,
}
