import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String reportId;
  final int type;
  final String companyId;
  final String ownId;
  final String ownPhotoURL;
  final String ownName;
  final DateTime createDate;
  final String nameReport;
  final String description;
  final List photoURL;
  final bool ownRead;
  final bool managerRead;
  const Report({
    required this.ownName,
    required this.type,
    required this.ownPhotoURL,
    required this.companyId,
    required this.ownId,
    required this.createDate,
    required this.nameReport,
    required this.description,
    required this.photoURL,
    required this.reportId,
    required this.ownRead,
    required this.managerRead,
  });

  Map<String, dynamic> toJson() => {
    'ownName' : ownName,
    'ownPhotoURL' : ownPhotoURL,
        'type': type,
        'companyId': companyId,
        'ownId': ownId,
        'nameReport': nameReport,
        'description': description,
        'photoURL': photoURL,
        'reportId': reportId,
        'createDate': createDate,
        'ownRead' : ownRead,
        'managerRead' : managerRead
      };

  static Report fromSnap({required DocumentSnapshot doc}) => Report( 
    ownName : doc['ownName'],
    ownPhotoURL : doc['ownPhotoURL'],
        type: doc['type'],
        ownId: doc['ownId'],
        nameReport: doc['nameReport'],
        description: doc['description'],
        reportId: doc['reportId'],
        createDate: doc['createDate'].toDate(),
        photoURL: doc['photoURL'],
        companyId: doc['companyId'],
        ownRead : doc['ownRead'],
        managerRead : doc['managerRead'],
      );
}
