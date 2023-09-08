import 'package:cloud_firestore/cloud_firestore.dart';

class Notify {
  final String notifyId;
  final bool isRead;
  final String userId;
  final DateTime createDate;
  final String missionId;
  final String nameMission;
  final String nameProject;
  final String username;
  final String description;
  final double percent;
  final int type;
  const Notify(
      {
        required this.percent,
        required this.username,
        required this.description,
        required this.notifyId,
      required this.isRead,
      required this.missionId,
      required this.nameMission,
      required this.nameProject,
      required this.userId,
      required this.createDate,
      required this.type});
  Map<String, dynamic> toJson() => {
    'percent' : percent,
    'username' : username,
    'description' : description,
        'notifyId': notifyId,
        'type': type,
        'isRead': isRead,
        'userId': userId,
        'createDate': createDate,
        'missionId': missionId,
        'nameMission': nameMission,
        'nameProject': nameProject
      };
  static Notify fromSnap({required DocumentSnapshot doc}) => Notify(
    percent: doc['percent'],
    description : doc['description'],
    username: doc['username'],
        missionId: doc['missionId'],
        nameMission: doc['nameMission'],
        nameProject: doc['nameProject'],
        notifyId: doc['notifyId'],
        type: doc['type'],
        isRead: doc['isRead'],
        userId: doc['userId'],
        createDate: doc['createDate'].toDate(),
      );
}
