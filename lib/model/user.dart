import 'package:cloud_firestore/cloud_firestore.dart';

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
  final int notifyNumber;

  const CurrentUser({
    required this.notifyNumber,
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
        'notifyNumber': notifyNumber
      };

  static CurrentUser fromSnap({required DocumentSnapshot user}) => CurrentUser(
      notifyNumber: user['notifyNumber'],
      email: user['email'],
      username: user['username'],
      password: user['password'],
      nameDetails: user['nameDetails'],
      photoURL: user['photoURL'],
      group: user['group'],
      userId: user['userId'],
      companyId: user['companyId'],
      companyName: user['companyName']);
}
