import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  final String nameProject;
  final String description;
  final String projectId;
  final String companyId;
  final DateTime createDate;
  final DateTime startDate;
  final DateTime endDate;
  final int missions;

  const Project({
    this.missions = 0,
    required this.companyId,
    required this.projectId,
    required this.nameProject,
    required this.description,
    required this.createDate,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() => {
        'companyId': companyId,
        'projectId': projectId,
        'nameProject': nameProject,
        'description': description,
        'createDate': createDate,
        'startDate': startDate,
        'endDate': endDate,
        'missions': missions,
      };

  static Project fromSnap(DocumentSnapshot project) {
    return Project(
      missions: project['missions'],
      companyId: project['companyId'],
      projectId: project['projectId'],
      nameProject: project['nameProject'],
      description: project['description'],
      createDate: project['createDate'].toDate(),
      startDate: project['startDate'].toDate(),
      endDate: project['endDate'].toDate(),
    );
  }
}
