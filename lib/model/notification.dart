import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management/utils/parameters.dart';

// manager receive notification when staff complete mission
class StaffCompleteMissionManagerNotify extends MissionNotify {
  final double percent;
  final String nameDetails;
  final String description;

  const StaffCompleteMissionManagerNotify(
      {required this.percent,
      required this.nameDetails,
      required this.description,
      required super.missionId,
      required super.nameMission,
      required super.nameProject,
      required super.notifyId,
      required super.isRead,
      required super.userId,
      required super.createDate,
      required super.type});
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({
      'percent': percent,
      'nameDetails': nameDetails,
      'description': description
    });
    return json;
  }

  static StaffCompleteMissionManagerNotify fromSnap(
          {required DocumentSnapshot doc}) =>
      StaffCompleteMissionManagerNotify(
        percent: doc['percent'],
        type: doc['type'],
        createDate: doc['createDate'].toDate(),
        userId: doc['userId'],
        isRead: doc['isRead'],
        notifyId: doc['notifyId'],
        nameProject: doc['nameProject'],
        nameMission: doc['nameMission'],
        nameDetails: doc['nameDetails'],
        missionId: doc['missionId'],
        description: doc['description'],
      );
}

// staff receive notification when mission deleted or change staff
class DeleteChangeMissionStaffNotify extends Notify {
  final String nameMission;
  final String nameProject;

  const DeleteChangeMissionStaffNotify(
      {required this.nameMission,
      required this.nameProject,
      required super.notifyId,
      required super.isRead,
      required super.userId,
      required super.createDate,
      required super.type});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({
      'nameMission': nameMission,
      'nameProject': nameProject,
    });
    return json;
  }

  static DeleteChangeMissionStaffNotify fromSnap(
          {required DocumentSnapshot doc}) =>
      DeleteChangeMissionStaffNotify(
        type: doc['type'],
        createDate: doc['createDate'].toDate(),
        userId: doc['userId'],
        isRead: doc['isRead'],
        notifyId: doc['notifyId'],
        nameProject: doc['nameProject'],
        nameMission: doc['nameMission'],
      );
}

// staff receive notification when manager time tracking
class TimekeepingStaffNotify extends Notify {
  final int state;
  final String date;

  TimekeepingStaffNotify(
      {required this.state,
      required this.date,
      required super.notifyId,
      required super.isRead,
      required super.userId,
      required super.createDate,
      required super.type});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({
      'state': state,
      'date': date,
    });
    return json;
  }

  static TimekeepingStaffNotify fromSnap({required DocumentSnapshot doc}) =>
      TimekeepingStaffNotify(
        type: doc['type'],
        createDate: doc['createDate'].toDate(),
        userId: doc['userId'],
        isRead: doc['isRead'],
        notifyId: doc['notifyId'],
        state: doc['state'],
        date: doc['date'],
      );
}

// manager receive notification when staff report
class ReceiveReportManagerNotify {}

// staff receive notification when manager upadate mission
class MissionNotify extends Notify {
  final String missionId;
  final String nameMission;
  final String nameProject;
  const MissionNotify(
      {required this.missionId,
      required this.nameMission,
      required this.nameProject,
      required super.notifyId,
      required super.isRead,
      required super.userId,
      required super.createDate,
      required super.type});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({
      'missionId': missionId,
      'nameMission': nameMission,
      'nameProject': nameProject,
    });
    return json;
  }

  static MissionNotify fromSnap({required DocumentSnapshot doc}) =>
      MissionNotify(
        type: doc['type'],
        createDate: doc['createDate'].toDate(),
        userId: doc['userId'],
        isRead: doc['isRead'],
        notifyId: doc['notifyId'],
        missionId: doc['missionId'],
        nameMission: doc['nameMission'],
        nameProject: doc['nameProject'],
      );
}

class Notify {
  final String notifyId;
  final bool isRead;
  final String userId;
  final DateTime createDate;
  final int type;
  const Notify(
      {required this.notifyId,
      required this.isRead,
      required this.userId,
      required this.createDate,
      required this.type});
  Map<String, dynamic> toJson() => {
        'notifyId': notifyId,
        'type': type,
        'isRead': isRead,
        'userId': userId,
        'createDate': createDate,
      };

  static getNotify({
    int state = 0,
    String date = '',
    String nameMission = '',
    String nameProject = '',
    double percent = 0,
    String nameDetails = '',
    String missionId = '',
    String description = '',
    String notifyId = '',
    bool isRead = true,
    String userId = '',
    DateTime? createDate,
    required int type,
    DocumentSnapshot? doc,
  }) {
    switch (type) {
      case TIME_KEEPING:
        return (doc != null)
            ? TimekeepingStaffNotify.fromSnap(doc: doc)
            : TimekeepingStaffNotify(
                state: state,
                date: date,
                notifyId: notifyId,
                isRead: isRead,
                userId: userId,
                createDate: createDate!,
                type: type);

      case MISSION_IS_DELETED || MISSION_CHANGE_STAFF:
        return (doc != null)
            ? DeleteChangeMissionStaffNotify.fromSnap(doc: doc)
            : DeleteChangeMissionStaffNotify(
                nameMission: nameMission,
                nameProject: nameProject,
                notifyId: notifyId,
                isRead: isRead,
                userId: userId,
                createDate: createDate!,
                type: type);
      case STAFF_COMPLETE_MISSION:
        return (doc != null)
            ? StaffCompleteMissionManagerNotify.fromSnap(doc: doc)
            : StaffCompleteMissionManagerNotify(
                percent: percent,
                nameDetails: nameDetails,
                description: description,
                missionId: missionId,
                nameMission: nameMission,
                nameProject: nameProject,
                notifyId: notifyId,
                isRead: isRead,
                userId: userId,
                createDate: createDate!,
                type: type);
      case STAFF_RECIEVE_MISSION ||
            STAFF_RECIEVE_MISSION_FROM_OTHER ||
            MISSION_IS_CHANGED ||
            MANAGER_APPROVE_PROGRESS ||
            MISSION_IS_OPEN:
        return (doc != null)
            ? MissionNotify.fromSnap(doc: doc)
            : MissionNotify(
                missionId: missionId,
                nameMission: nameMission,
                nameProject: nameProject,
                notifyId: notifyId,
                isRead: isRead,
                userId: userId,
                createDate: createDate!,
                type: type);

      default:
        return null;
    }
  }
}
