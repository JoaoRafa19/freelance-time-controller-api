// import 'dart:convert';
// import 'dart:io';
// import 'package:shelf/shelf.dart';
// import 'package:uuid/uuid.dart';

// import '../core/database/database.dart';
// import '../core/shared/utils.dart';
// import 'user_repository.dart';

// class AuthRepository {
//   //singleton
//   static final AuthRepository instance = AuthRepository._internal();
//   factory AuthRepository() => instance;
//   AuthRepository._internal();

//   //database
//   static const String collectionName = 'user';
//   static const String collectionNameToken = 'token';
//   static const String collectionSessionName = 'sessions';

//   String secret = 'secret';

//   Future<Response> login(String email, String password) async {
//     try {
//       final UserRepository userRepository = UserRepository.instance;
//       final db = await Database().openConnection();
//       final user = await userRepository.findByEmail(email);
//       if (user == null) {
//         throw Exception("User not found");
//       }
//       if (await Utils.hashPassword(password) == user.password) {
//         Map<String, dynamic> session = {
//           'username': user.email,
//           'sessionToken': Uuid().v4()
//         };
//         await db.collection(collectionSessionName).insert(session);

//         return Response.ok(jsonEncode(session));
//       } else {
//         final response = Response(HttpStatus.unauthorized,
//             body: 'forbiden incorrect user and/or password');

//         return response;
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
