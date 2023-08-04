class CurrentUser {
  final String email;
  final String username;
  final String password;
  final String nameDetails;
  final String photoURL;
  final String group;
  final String userId;
  final String companyId;
  final String companyName;

  const CurrentUser({
    required this.email,
    required this.username,
    required this.password,
    required this.nameDetails,
    required this.photoURL,
    required this.group,
    required this.userId,
    required this.companyId,
    required this.companyName,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'username': username,
        'password': password,
        'nameDetails': nameDetails,
        'photoURL': photoURL,
        'group': group,
        'userId': userId,
        'companyId': companyId,
        'companyName': companyName,
      };
}
