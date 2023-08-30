import 'package:cloud_firestore/cloud_firestore.dart';

class Mission {
  final String companyId;
  final String projectId;
  final String missionId;
  final String nameMission;
  final String description;
  final DateTime createDate;
  final DateTime startDate;
  final DateTime endDate;
  final Map<dynamic, String> dateDetail;
  final Map<dynamic, double> datePercent;
  final double percent;
  final String staffId;

  const Mission({
    required this.companyId,
    required this.projectId,
    required this.missionId,
    required this.nameMission,
    required this.description,
    required this.createDate,
    required this.startDate,
    required this.endDate,
    required this.datePercent,
    required this.dateDetail,
    required this.percent,
    required this.staffId,
  });

  Map<String, dynamic> toJson() => {
    'companyId' : companyId,
    'projectId' : projectId,
    'missionId' : missionId,
    'nameMission' : nameMission,
    'description' : description,
    'createDate' : createDate,
    'startDate' : startDate,
    'endDate' : endDate,
    'dateDetail' : dateDetail,
    'datePercent' : datePercent,
    'percent' : percent,
    'staffId' : staffId,
  };

  static Mission fromSnap({required DocumentSnapshot mission}) => Mission(
      companyId: mission['companyId'],
      projectId: mission['projectId'],
      missionId: mission['missionId'],
      nameMission: mission['nameMission'],
      description: mission['description'],
      createDate: mission['createDate'].toDate(),
      startDate: mission['startDate'].toDate(),
      endDate: mission['endDate'].toDate(),
      percent: mission['percent'],
      staffId: mission['staffId'],
      dateDetail: mission['dateDetail'],
      datePercent: mission['datePercent']);
}
