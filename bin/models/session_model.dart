import 'package:uuid/uuid.dart';

import '../core/shared/coreconfig.dart';

class Session {
  final String username;
  final String sessionToken;
  final DateTime expiresAt;

  Session(
      {required this.username,
      required this.sessionToken,
      required this.expiresAt});

  factory Session.newSession(String username) {
    return Session(
        username: username,
        sessionToken: Uuid().v4(),
        expiresAt: DateTime.now().add(Config.expiresIn));
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      username: json['username'],
      sessionToken: json['sessionToken'],
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'sessionToken': sessionToken,
      'expiresAt': expiresAt.toString(),
    };
  }
}
