class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime dateJoined;
  final bool isValidated;
  final String roleType;
  final String? token;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.token,
    required this.dateJoined,
    required this.roleType,
    required this.isValidated,
  });

  factory User.fromJson(Map<String, dynamic> json, String token) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      token: token,
      dateJoined: DateTime.parse(json['dateJoined']),
      roleType: json['roleType'],
      isValidated: json['validated'] ?? false,
    );
  }
}
