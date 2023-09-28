import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String reportId;
  final int type;
  final String companyId;
  final String ownId;
  final DateTime createDate;
  final String nameReport;
  final String description;
  final List photoURL;
  final bool isRead;
  const Report({
    required this.type,
    required this.companyId,
    required this.ownId,
    required this.createDate,
    required this.nameReport,
    required this.description,
    required this.photoURL,
    required this.reportId,
    required this.isRead,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'companyId': companyId,
        'ownId': ownId,
        'nameReport': nameReport,
        'description': description,
        'photoURL': photoURL,
        'reportId': reportId,
        'createDate': createDate,
        'isRead' : isRead
      };

  static Report fromSnap({required DocumentSnapshot doc}) => Report(
        type: doc['type'],
        ownId: doc['ownId'],
        nameReport: doc['nameReport'],
        description: doc['description'],
        reportId: doc['reportId'],
        createDate: doc['createDate'].toDate(),
        photoURL: doc['photoURL'],
        companyId: doc['companyId'],
        isRead : doc['isRead'],
      );
}
