
class CurrentUser {
  final String email;
  final String username;
  final String password;
  final String nameDetails;
  final String role;
  final String userId;
  final bool isManager;
  final String managerId;
  final String managerEmail;

  const CurrentUser(
      {required this.email,
      required this.username,
      required this.password,
      required this.isManager,
      required this.nameDetails,
      required this.role,
      required this.userId,
      required this.managerId,
      required this.managerEmail});

  Map<String, dynamic> toJson() => {
        'email': email,
        'username': username,
        'password': password,
        'isManager': isManager,
        'nameDetails': nameDetails,
        'role': role,
        'userId': userId,
        'managerId': managerId,
        'managerEmail': managerEmail,
      };
}
