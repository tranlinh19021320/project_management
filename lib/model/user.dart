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
  final int reportNumber;
  final Map<String, dynamic> timekeeping;

  const CurrentUser({
    required this.timekeeping,
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
    required this.reportNumber,
  });

  Map<String, dynamic> toJson() => {
    'timekeeping' : timekeeping,
        'email': email,
        'username': username,
        'password': password,
        'nameDetails': nameDetails,
        'photoURL': photoURL,
        'group': group,
        'userId': userId,
        'companyId': companyId,
        'companyName': companyName,
        'notifyNumber': notifyNumber,
        'reportNumber':reportNumber
      };

  static CurrentUser fromSnap({required DocumentSnapshot doc}) => CurrentUser(
    timekeeping: doc['timekeeping'] ,
      notifyNumber: doc['notifyNumber'],
      email: doc['email'],
      username: doc['username'],
      password: doc['password'],
      nameDetails: doc['nameDetails'],
      photoURL: doc['photoURL'],
      group: doc['group'],
      userId: doc['userId'],
      companyId: doc['companyId'],
      companyName: doc['companyName'],
      reportNumber : doc['reportNumber']);
}
