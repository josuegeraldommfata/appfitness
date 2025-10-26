class AuthUser {
  final String username;
  final String password;
  final String role; // 'user' or 'admin'
  final String userId; // reference to User model

  AuthUser({
    required this.username,
    required this.password,
    required this.role,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'role': role,
      'userId': userId,
    };
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      username: json['username'],
      password: json['password'],
      role: json['role'],
      userId: json['userId'],
    );
  }
}
