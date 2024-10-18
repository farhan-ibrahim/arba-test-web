class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return User(
        id: 0,
        name: '',
        email: '',
      );
    }

    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
