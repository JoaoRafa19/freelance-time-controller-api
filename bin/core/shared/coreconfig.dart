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
  String get portStr => dotenv.map[Strings.port.value] ?? '3000';
  int get port => int.parse(portStr);
  String? get database => dotenv.map[Strings.database.value];
  String get address => InternetAddress.anyIPv4.address;
  static void initialize(List<String> enviroment) async {
    try {
      if (!enviroment.contains(Strings.devenv.value)) {
        env = Enviroment.prod;
      }
      dotenv.load(enviroment);
      if (dotenv.isEveryDefined(_defaultEnvParams)) {
        print('Config loaded');
      } else {
        _defaultEnvParams.removeWhere((e) => dotenv.map[e] != null);
        throw Exception(
            "Config not loaded, missing enviroment variables \n ${_defaultEnvParams.join(', ')}");
      }
    } catch (e) {
      print(e);
      exit(1);
    }
  }
}

enum Enviroment {
  dev,
  prod,
}
