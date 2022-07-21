class User {
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final int role;

  User({this.id, this.name, this.email, this.password = '', this.role = 0});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id:json['id'] as String?,
      name:json['name'] as String?,
      email:json['email'] as String?,
      password:json['password'] as String?,
      role:json['role'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
