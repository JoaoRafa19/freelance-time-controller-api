import 'dart:convert';

import 'package:crypto/crypto.dart';

class Utils {


  static Future<String> hashPassword(String password) async {
    var bytes = utf8.encode(password);
    var digest = sha1.convert(bytes);

    return digest.toString();
  }
}