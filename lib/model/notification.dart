import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management/model/mission.dart';

class Notify {
  final String notifyId;
  final bool isRead;
  final String userId;
  final DateTime createDate;
  final Mission mission;
  final int type;
  const Notify(
      {required this.notifyId,
        required this.isRead,
      required this.mission,
      required this.userId,
      required this.createDate,
      required this.type});
  Map<String, dynamic> toJson() => {
    'notifyId' : notifyId,
        'type': type,
        'isRead': isRead,
        'userId': userId,
        'createDate': createDate,
        'missionId': mission.missionId,
      };
  static Future<Notify> fromSnap({required DocumentSnapshot doc}) async {
    String missionId = doc['missionId'];
    var snap = await FirebaseFirestore.instance
        .collection('missions')
        .doc(missionId)
        .get();
    Mission mission = Mission.fromSnap(mission: snap);

    return Notify(
      notifyId : doc['notifyId'],
      type: doc['type'],
      isRead: doc['isRead'],
      userId: doc['userId'],
      createDate: doc['createDate'].toDate(),
      mission: mission,
    );
  }
}
