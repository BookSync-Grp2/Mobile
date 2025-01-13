class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String token;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json, String token) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      token: token,
    );
  }
}
