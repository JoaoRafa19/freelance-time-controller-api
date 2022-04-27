class User {
  final int? id;
  final String? name;
  final String? email;
  final String? password;

  User({this.id, this.name, this.email, this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id:json['id'] as int?,
      name:json['name'] as String?,
      email:json['email'] as String?,
      password:json['password'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
