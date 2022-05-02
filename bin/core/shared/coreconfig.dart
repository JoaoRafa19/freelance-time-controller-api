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

  static DotEnv dotenv = DotEnv(includePlatformEnvironment: true);
  String get portStr => dotenv.map['PORT'] ?? '3000';
  int get port => int.parse(portStr);
  String? get mongoUrl => dotenv.map['MONGO_URL'];
  String get address => InternetAddress.anyIPv4.address;
  static void initialize(List<String> enviroment) {
    dotenv.load(enviroment);
    if (dotenv.isEveryDefined(['PORT', 'MONGO_URL'])) {
      print('Config loaded');
    } else {
      throw Exception("Config not loaded");
    }
  }
}


